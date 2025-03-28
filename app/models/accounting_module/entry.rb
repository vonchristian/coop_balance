module AccountingModule
  class Entry < ApplicationRecord
    include PgSearch::Model

    pg_search_scope :text_search, against: %i[reference_number description]
    multisearchable against: %i[reference_number description]

    has_one    :voucher, dependent: :nullify
    belongs_to :recording_agent,       polymorphic: true, optional: true
    belongs_to :commercial_document,   polymorphic: true
    belongs_to :cancellation_entry,    class_name: "AccountingModule::Entry", optional: true
    belongs_to :office,                class_name: "Cooperatives::Office", optional: true
    belongs_to :cooperative, optional: true
    belongs_to :cancelled_by,          class_name: "User", optional: true
    belongs_to :recorder,              class_name: "User", optional: true
    has_many   :credit_amounts,        class_name: "AccountingModule::CreditAmount", dependent: :destroy
    has_many   :debit_amounts,         class_name: "AccountingModule::DebitAmount", dependent: :destroy
    has_many   :credit_accounts,       class_name: "AccountingModule::Account", through: :credit_amounts, source: :account
    has_many   :debit_accounts,        class_name: "AccountingModule::Account", through: :debit_amounts,  source: :account
    has_many   :amounts,               class_name: "AccountingModule::Amount", dependent: :destroy
    has_many   :accounts,              class_name: "AccountingModule::Account", through: :amounts

    validates :description, :reference_number, :entry_date, :entry_time, presence: true

    validate :has_credit_amounts?
    validate :has_debit_amounts?
    validate :amounts_cancel?

    accepts_nested_attributes_for :credit_amounts, :debit_amounts, allow_destroy: true

    before_save :set_default_date

    delegate :name,  :first_and_last_name, to: :recorder, prefix: true
    delegate :name,  to: :cooperative, prefix: true
    delegate :name,  to: :office, prefix: true
    delegate :name,  to: :commercial_document, prefix: true, allow_nil: true

    def self.recent
      order(created_at: :desc).first
    end

    # for sorting entries in reports
    def ascending_order
      reference_number.to_i
    end

    def self.loan_payments(_args = {})
      ids = amounts.for_loans.pluck(:entry_id).uniq.flatten
      not_cancelled.where(id: ids)
    end

    def self.not_cancelled
      where(cancelled: false)
    end

    def self.cancelled
      where(cancelled: true)
    end

    def self.amounts
      ids = pluck(:id)
      AccountingModule::Amount.where(entry_id: ids)
    end

    def self.accounts
      accounts = amounts.pluck(:account_id)
      AccountingModule::Account.where(id: accounts)
    end

    def self.without_cash_accounts
      ids = (all - where(id: amounts.with_cash_accounts.pluck(:entry_id).uniq)).pluck(:id)
      where(id: ids)
    end

    def self.with_cash_accounts
      ids = amounts.with_cash_accounts.pluck(:entry_id)
      where(id: ids)
    end

    def self.not_archived
      where(archived: false)
    end

    def self.archived
      where(archived: true)
    end

    def self.entered_on(args = {})
      from_date = args[:from_date]
      to_date   = args[:to_date]
      if from_date && to_date
        date_range = DateRange.new(from_date: from_date, to_date: to_date)
        where("entry_date" => (date_range.start_date..date_range.end_date))
      else
        all
      end
    end

    def self.recorded_by(args = {})
      where(recorder: args[:recorder])
    end

    def self.total
      all.sum(&:total)
    end

    def self.debit_amounts(_args = {})
      AccountingModule::DebitAmount.where(entry_id: pluck(:id))
    end

    def self.credit_amounts(_args = {})
      AccountingModule::CreditAmount.where(entry_id: pluck(:id))
    end

    def not_cancelled?
      cancelled_at.nil?
    end

    delegate :total, to: :credit_amounts

    def total_cash_amount(_args = {})
      amounts.total_cash_amount
    end

    def contains_cash_account?
      amounts.with_cash_accounts.present?
    end

    delegate :accounts, to: :amounts

    def cancelled?
      cancelled == true
    end

    # show on pdf reports
    def cancellation_text
      if cancelled?
        "CANCELLED"
      else
        ""
      end
    end

    def self.for_loans
      joins(:amounts).where("amounts.commercial_document_type" => "LoansModule::Loan")
    end

    def display_commercial_document
      if commercial_document.try(:member).present?
        commercial_document.try(:member).try(:full_name)
      elsif commercial_document.try(:borrower).present?
        commercial_document.try(:borrower).try(:full_name)
      else
        commercial_document.try(:name)
      end
    end

    # for entry sorting on transactions
    def entry_date_and_created_at
      EntryDateTime.new(entry: self).set
    end

    private

    def set_default_date
      return if entry_date.present?

      self.entry_date = Time.zone.now
    end

    def has_credit_amounts?
      errors.add(:base, "Entry must have at least one credit amount") if credit_amounts.blank?
    end

    def has_debit_amounts?
      errors.add(:base, "Entry must have at least one debit amount") if debit_amounts.blank?
    end

    def amounts_cancel?
      errors.add(:base, "The credit and debit amounts are not equal") if credit_amounts.balance_for_new_record != debit_amounts.balance_for_new_record
    end
  end
end
