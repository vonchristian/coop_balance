#ensure debits and credits are equal
class Voucher < ApplicationRecord
  include PgSearch
  has_secure_token
  pg_search_scope :text_search, :against => [:number, :description]
  multisearchable against: [:number, :description]

  has_one :entry,            class_name: "AccountingModule::Entry", as: :commercial_document
  belongs_to :accounting_entry, class_name: "AccountingModule::Entry", foreign_key: 'entry_id'
  belongs_to :payee,         polymorphic: true
  belongs_to :commercial_document,         polymorphic: true #orders
  belongs_to :preparer,      class_name: "User", foreign_key: 'preparer_id'
  belongs_to :disburser,     class_name: "User", foreign_key: 'disburser_id'
  has_many :voucher_amounts, class_name: "Vouchers::VoucherAmount", dependent: :destroy
  has_many :loans, class_name: "LoansModule::Loan"
  delegate :full_name, :current_occupation, to: :preparer, prefix: true
  delegate :full_name, :current_occupation, to: :disburser, prefix: true, allow_nil: true
  delegate :name, to: :payee, prefix: true
  delegate :avatar, to: :payee, allow_nil: true
  before_save :set_default_date
  # validate :has_credit_amounts?
  # validate :has_debit_amounts?
  validate :amounts_cancel?
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
    Supplier.all
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
    "#{number} - #{total}"
  end

  def self.disbursed(args={})
    if args[:from_date] && args[:to_date]
      date_range = DateRange.new(from_date: args[:from_date], to_date: args[:to_date])
      where.not(entry_id: nil).includes([:accounting_entry]).where('entries.entry_date' => (date_range.start_date..date_range.end_date))
    else
      where.not(entry_id: nil)
    end
  end

  def disbursed?
    accounting_entry.present?
  end

  def add_amounts(payee)
    self.voucher_amounts << payee.voucher_amounts
    payee.voucher_amounts.each do |v|
      v.commercial_document_id = nil
      v.commercial_document_type = nil
      v.save
    end
  end

  def self.generate_number_for(voucher)
    return  voucher.number = Voucher.order(created_at: :asc).last.number.succ if Voucher.exists? && Voucher.order(created_at: :asc).last.number.present?
    voucher.number = "000000000001"
  end

  def valid_for?(cart)
    cart.total_cost == self.entry.debit_amounts.total && self.commercial_document.nil?
  end

  private
  def set_default_date
    self.date ||= Time.zone.now
  end
  def has_credit_amounts?
    errors[:base] << "Voucher must have at least one credit amount" if self.voucher_amounts.credit.blank?
  end

  def has_debit_amounts?
    errors[:base] << "Voucher must have at least one debit amount" if self.voucher_amounts.debit.blank?
  end

  def amounts_cancel?
    errors[:base] << "The credit and debit amounts are not equal" if voucher_amounts.credit.balance_for_new_record != voucher_amounts.debit.balance_for_new_record
  end
end
