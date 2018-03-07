module AccountingModule
  class Entry < ApplicationRecord
    include PgSearch
    pg_search_scope :text_search, :against => [:reference_number, :description]
    multisearchable against: [:reference_number, :description]
    enum payment_type: [:cash, :check]

    belongs_to :commercial_document, :polymorphic => true, touch: true
    belongs_to :origin, :polymorphic => true, touch: true
    belongs_to :recorder, foreign_key: 'recorder_id', class_name: "User"
    has_many :credit_amounts, extend: AccountingModule::BalanceFinder, :class_name => 'AccountingModule::CreditAmount', :inverse_of => :entry, dependent: :destroy
    has_many :debit_amounts, extend: AccountingModule::BalanceFinder, :class_name => 'AccountingModule::DebitAmount', :inverse_of => :entry, dependent: :destroy
    has_many :credit_accounts, :through => :credit_amounts, :source => :account, :class_name => 'AccountingModule::Account'
    has_many :debit_accounts, :through => :debit_amounts, :source => :account, :class_name => 'AccountingModule::Account'
    has_many :amounts, class_name: "AccountingModule::Amount"
    has_many :accounts, class_name: "AccountingModule::Account", through: :amounts

    validates :description, presence: true
    validates :origin_id, :recorder_id, presence: true
    validate :has_credit_amounts?
    validate :has_debit_amounts?
    validate :amounts_cancel?

    accepts_nested_attributes_for :credit_amounts, :debit_amounts, allow_destroy: true

    before_save :set_default_date, :set_office
    after_commit :update_accounts, :update_amounts

    delegate :first_and_last_name, to: :recorder, prefix: true, allow_nil: true
    delegate :number, to: :voucher, prefix: true, allow_nil: true
    delegate :name, to: :origin, prefix: true, allow_nil: true
    delegate :name, to: :recorder, prefix: true, allow_nil: true
    def self.loan_payments(options={})
      entries = []
      LoansModule::LoanProduct.accounts.each do |account|
        account.credit_entries.entered_on(options).each do |entry|
          entries << entry
        end
      end
      entries
    end

    def self.entered_on(options={})
      EntriesQuery.new.entered_on(options)
    end

    def self.recorded_by(employee_id)
      where(recorder_id: employee_id )
    end



    def self.total
      all.map{|a| a.credit_amounts.sum(:amount)}.sum
    end

    private
      def set_office
        self.origin = self.recorder.office
      end
      def set_default_date
        todays_date = ActiveRecord::Base.default_timezone == :utc ? Time.now.utc : Time.now
        self.entry_date ||= todays_date
      end
      def update_accounts
        self.accounts.update_all(updated_at: self.entry_date)
      end
      def update_amounts
        self.amounts.update_all(recorder_id: self.recorder_id)
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
