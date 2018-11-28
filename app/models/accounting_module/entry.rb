module AccountingModule
  class Entry < ApplicationRecord
    audited
    include PgSearch
    pg_search_scope :text_search, :against => [:reference_number, :description]
    multisearchable against: [:reference_number, :description]

    enum payment_type: [:cash, :check]

    has_one :voucher, foreign_key: 'entry_id', dependent: :nullify
    belongs_to :official_receipt, optional: true
    belongs_to :previous_entry, class_name: "AccountingModule::Entry", optional: true
    belongs_to :commercial_document, :polymorphic => true
    belongs_to :office, class_name: "CoopConfigurationsModule::Office"
    belongs_to :cooperative
    belongs_to :cooperative_service, optional: true, class_name: "CoopServicesModule::CooperativeService"
    belongs_to :cancelled_by, class_name: "User", foreign_key: 'cancelled_by_id'
    belongs_to :recorder, foreign_key: 'recorder_id', class_name: "User"
    has_many :referenced_entries, class_name: "AccountingModule::Entry", foreign_key: 'previous_entry_id', dependent: :nullify
    has_many :credit_amounts, extend: AccountingModule::BalanceFinder, :class_name => 'AccountingModule::CreditAmount', :inverse_of => :entry, dependent: :destroy
    has_many :debit_amounts, extend: AccountingModule::BalanceFinder, :class_name => 'AccountingModule::DebitAmount', :inverse_of => :entry, dependent: :destroy
    has_many :credit_accounts, :through => :credit_amounts, :source => :account, :class_name => 'AccountingModule::Account'
    has_many :debit_accounts, :through => :debit_amounts, :source => :account, :class_name => 'AccountingModule::Account'
    has_many :amounts, class_name: "AccountingModule::Amount", dependent: :destroy
    has_many :accounts, class_name: "AccountingModule::Account", through: :amounts

    validates :description, presence: true
    validates :previous_entry_id, presence: true, if: :entries_present?
    validates :office_id, :cooperative_id, :recorder_id, presence: true

    validate :has_credit_amounts?
    validate :has_debit_amounts?
    validate :amounts_cancel?

    accepts_nested_attributes_for :credit_amounts, :debit_amounts, allow_destroy: true

    before_validation :set_default_date, on: :create
    after_commit :set_encrypted_hash!, if: :entries_present?

    delegate :name, :first_and_last_name, to: :recorder, prefix: true, allow_nil: true
    delegate :name, to: :cooperative, prefix: true
    delegate :name, to: :office, prefix: true
    delegate :name, to: :commercial_document, prefix: true, allow_nil: true
    delegate :title, to: :cooperative_service, prefix: true, allow_nil: true

    def self.recent
      order(created_at: :desc).first
    end

    def self.not_cancelled
      where(cancelled: false)
    end

    def self.cancelled
      where(cancelled: true)
    end

    def self.not_archived
      where(archived: false)
    end

    def self.archived
      where(archived: true)
    end


    def self.entered_on(args={})
      EntriesQuery.new.entered_on(args)
    end

    def self.recorded_by(args={})
      where(recorder: args[:recorder] )
    end

    def self.total
      all.map{|a| a.total }.sum
    end

    def entries_present?
      AccountingModule::Entry.exists?
    end

    def total
      credit_amounts.total
    end
    def total_cash_amount
      amounts.total_cash_amount
    end

    def unbalanced?
      credit_amounts.sum(:amount) != debit_amounts.sum(:amount)
    end

    def hashes_valid?
      encrypted_hash == digested_hash
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
    private

    def set_encrypted_hash!
      if encrypted_hash.blank?
        self.update_attributes!(encrypted_hash: digested_hash, updated_at: self.created_at.strftime("%B %e, %Y"))
      end
    end

    def digested_hash
      Digest::SHA256.hexdigest(self.digestable)
    end

      def set_default_date
        todays_date = ActiveRecord::Base.default_timezone == :utc ? Time.now.utc : Time.now
        self.entry_date ||= todays_date
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
      # def destroy
      #   # raise "Cannot destroy entry"
      #   # super
      # end
  end
end
