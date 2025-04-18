class TreasuryModule::Voucher < ApplicationRecord
  include PgSearch::Model

  has_secure_token
  pg_search_scope :text_search, against: %i[reference_number description]
  multisearchable against: %i[number description]

  belongs_to :cooperative, optional: true
  belongs_to :store_front,         optional: true
  belongs_to :cooperative_service, class_name: "CoopServicesModule::CooperativeService", optional: true
  belongs_to :office,              class_name: "Cooperatives::Office", optional: true
  belongs_to :accounting_entry,    class_name: "AccountingModule::Entry", foreign_key: "entry_id", optional: true
  belongs_to :payee,               polymorphic: true
  belongs_to :commercial_document, polymorphic: true, optional: true # attaching voucher to orders
  belongs_to :preparer,            class_name: "User", optional: true
  belongs_to :recording_agent,     polymorphic: true, optional: true
  belongs_to :disbursing_agent,    polymorphic: true, optional: true
  belongs_to :origin,              polymorphic: true, optional: true
  belongs_to :disburser,           class_name: "User", optional: true
  has_many :voucher_amounts,       class_name: "Vouchers::VoucherAmount", dependent: :destroy

  delegate :title, to: :cooperative_service, prefix: true, allow_nil: true
  delegate :name, :abbreviated_name, :address, :contact_number, to: :cooperative, prefix: true
  delegate :full_name, :current_occupation, to: :preparer, prefix: true
  delegate :full_name, :current_occupation, to: :disburser, prefix: true, allow_nil: true
  delegate :name, to: :payee, prefix: true, allow_nil: true
  delegate :avatar, to: :payee, allow_nil: true

  validates :account_number, presence: true, uniqueness: true
  before_save :set_default_date
  # validate :has_credit_amounts?
  # validate :has_debit_amounts?
  # validate :amounts_cancel?

  def self.loan_disbursement_vouchers
    vouchers = LoansModule::Loan.pluck(:disbursement_voucher_id)
    where(id: vouchers)
  end

  def self.contains_cash_accounts
    vouchers = Vouchers::VoucherAmount.contains_cash_accounts.pluck(:voucher_id)
    where(id: vouchers)
  end

  def cancelled?
    cancelled_at.present?
  end

  def entry
    accounting_entry
  end

  delegate :total_cash_amount, to: :voucher_amounts

  def name
    payee_name
  end

  def self.unearned
    where(unearned: true)
  end

  def self.payees
    User.all +
      Member.all +
      Organization.all +
      StoreFrontModule::Supplier.all
  end

  def self.unused
    where(commercial_document_id: nil)
  end

  def total
    if disbursed?
      entry.debit_amounts.sum(&:amount)
    else
      voucher_amounts.sum(&:amount)
    end
  end

  def number_and_total
    "#{reference_number} - #{total}"
  end

  def self.disbursed
    where.not(entry_id: nil)
  end

  def self.disbursed_on(args = {})
    if args[:from_date] && args[:to_date]
      range = DateRange.new(from_date: args[:from_date], to_date: args[:to_date])
      disbursed.joins(:accounting_entry).where("entries.entry_date" => (range.start_date..range.end_date))
    else
      disbursed
    end
  end

  def disbursed?
    entry_id.present?
  end

  def self.latest
    pluck(:number).max
  end

  def self.generate_number
    return "000000000001" if blank?

    pluck(:number).compact!.max.next
  end

  def valid_for?(cart)
    cart.total_cost == entry.debit_amounts.total && commercial_document.nil?
  end

  def disbursing_officer
    if disbursed?
      disburser
    else
      # id = voucher_amounts.contains_cash_accounts.pluck(:account_id).last
      # employee = Employees::EmployeeCashAccount.where(cash_account_id: id).last.employee
      Employees::EmployeeCashAccount.last.employee
    end
  end

  def contains_cash_accounts?
    voucher_amounts.contains_cash_accounts.present?
  end

  private

  def set_default_date
    self.date ||= Time.zone.now
  end

  def has_credit_amounts?
    errors.add(:base, "Voucher must have at least one credit amount") if voucher_amounts.credit.blank?
  end

  def has_debit_amounts?
    errors.add(:base, "Voucher must have at least one debit amount") if voucher_amounts.debit.blank?
  end

  def amounts_cancel?
    errors.add(:base, "The credit and debit amounts are not equal") if voucher_amounts.credit.total != voucher_amounts.debit.total
  end
end
