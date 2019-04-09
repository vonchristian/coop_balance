module AccountingModule
  class Entry < ApplicationRecord
    audited
    include PgSearch
    include Taggable
    pg_search_scope :text_search, :against => [:reference_number, :description]
    multisearchable against: [:reference_number, :description]

    enum payment_type: [:cash, :check]

    has_one    :voucher,               foreign_key: 'entry_id', dependent: :nullify
    belongs_to :official_receipt,      optional: true
    belongs_to :previous_entry,        class_name: "AccountingModule::Entry", foreign_key: 'previous_entry_id'
    belongs_to :commercial_document,   polymorphic: true
    belongs_to :office,                class_name: "Cooperatives::Office"
    belongs_to :cooperative
    belongs_to :cooperative_service,   class_name: "CoopServicesModule::CooperativeService", optional: true
    belongs_to :cancelled_by,          class_name: "User", foreign_key: 'cancelled_by_id'
    belongs_to :recorder,              class_name: "User", foreign_key: 'recorder_id'
    has_many   :referenced_entries,    class_name: "AccountingModule::Entry", foreign_key: 'previous_entry_id', dependent: :nullify
    has_many   :credit_amounts,        class_name: 'AccountingModule::CreditAmount', dependent: :destroy
    has_many   :debit_amounts,         class_name: 'AccountingModule::DebitAmount', dependent: :destroy
    has_many   :credit_accounts,       class_name: 'AccountingModule::Account', through: :credit_amounts, source: :account
    has_many   :debit_accounts,        class_name: 'AccountingModule::Account', through: :debit_amounts,  source: :account
    has_many   :amounts,               class_name: "AccountingModule::Amount", dependent: :destroy
    has_many   :accounts,              class_name: "AccountingModule::Account", through: :amounts

    validates :description, presence: true
    validates :previous_entry_id, presence: true, if: :entries_present?
    validates :office_id, :cooperative_id, :recorder_id, presence: true

    validate :has_credit_amounts?
    validate :has_debit_amounts?
    validate :amounts_cancel?

    accepts_nested_attributes_for :credit_amounts, :debit_amounts, allow_destroy: true

    before_save :set_default_date, :set_entry_date_to_datetime, on: :create
    after_commit :set_encrypted_hash!, if: :entries_present?

    delegate :name,  :first_and_last_name, to: :recorder, prefix: true, allow_nil: true
    delegate :name,  to: :cooperative, prefix: true
    delegate :name,  to: :office, prefix: true
    delegate :name,  to: :commercial_document, prefix: true, allow_nil: true
    delegate :title, to: :cooperative_service, prefix: true, allow_nil: true


    def self.recent
      order(created_at: :desc).first
    end

    def ascending_order #for sorting entries in reports
      reference_number.to_i
    end

    def self.loan_payments(args={})
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
      ids = self.pluck(:id)
      AccountingModule::Amount.where(entry_id: ids)
    end

    def self.accounts
      accounts = amounts.pluck(:account_id)
      AccountingModule::Account.where(id: accounts)
    end

    def self.without_cash_accounts
      ids = (self.all - where(id: amounts.with_cash_accounts.pluck(:entry_id).uniq)).pluck(:id)
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


    def self.entered_on(args={})
      from_date = args[:from_date]
      to_date   = args[:to_date]
      if from_date && to_date
        date_range = DateRange.new(from_date: from_date, to_date: to_date)
        where('entry_date' => (date_range.start_date..date_range.end_date))
      else
        all
      end
    end

    def self.recorded_by(args={})
      where(recorder: args[:recorder] )
    end

    def self.total
      all.map{|a| a.total }.sum
    end

    def self.debit_amounts(args={})
      AccountingModule::DebitAmount.where(entry_id: all.pluck(:id))
    end

    def self.credit_amounts(args={})
      AccountingModule::CreditAmount.where(entry_id: all.pluck(:id))
    end

    def not_cancelled?
      cancelled_at.nil?
    end

    def entries_present?
      AccountingModule::Entry.exists?
    end

    def total
      credit_amounts.total
    end

    def total_cash_amount(args={})
      amounts.total_cash_amount
    end

    def hashes_valid?
      encrypted_hash == digested_hash
    end

    def contains_cash_account?
      amounts.with_cash_accounts.present?
    end

    def accounts
      amounts.accounts
    end

    def digested_hash
      Digest::SHA256.hexdigest(self.digestable)
    end

    def digestable
      "#{amounts.count.to_s}
      #{amounts.sum(:amount_cents).to_s}
      #{amounts.pluck(:account_id).join("," "")}
      #{entry_date.to_s}
      #{cooperative_id.to_s}
      #{office_id.to_s}
      #{commercial_document_id.to_s}
      #{commercial_document_type.to_s}
      #{previous_entry_id}
      #{recorder_id.to_s}
      #{previous_entry_hash}"
    end

    def cancelled?
      cancelled == true
    end

    def cancellation_text #show on pdf reports
      if cancelled?
        "CANCELLED"
      else
        ""
      end
    end

    def self.for_loans
      joins(:amounts).where('amounts.commercial_document_type' => "LoansModule::Loan")
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

    def entry_date_and_created_at #for entry sorting on transactions
      EntryDateTime.new(entry: self).set
    end

    private
    def set_encrypted_hash!
      if encrypted_hash.blank?
        self.update_attributes!(
          encrypted_hash: digested_hash,
          updated_at: created_at.strftime("%B %e, %Y")
        )
      end
    end

    def set_default_date
      if entry_date.blank?
        todays_date = ActiveRecord::Base.default_timezone == :utc ? Time.now.utc : Time.now
        self.entry_date = todays_date
      end
    end

    def set_entry_date_to_datetime
      if self.persisted?
        date_and_time = Time.zone.local(self.entry_date.year, self.entry_date.month, self.entry_date.day, created_at.hour, created_at.min, created_at.sec)
      else
        date_and_time = Time.zone.local(self.entry_date.year, self.entry_date.month, self.entry_date.day, Time.zone.now.hour, Time.zone.now.min, Time.zone.now.sec)
      end
      self.entry_date = date_and_time
    end

    def has_credit_amounts?
      errors[:base] << "Entry must have at least one credit amount" if self.credit_amounts.blank?
    end

    def has_debit_amounts?
      errors[:base] << "Entry must have at least one debit amount" if self.debit_amounts.blank?
    end

    def amounts_cancel?
      errors[:base] << "The credit and debit amounts are not equal" if credit_amounts.balance_for_new_record != debit_amounts.balance_for_new_record
    end
  end
end
