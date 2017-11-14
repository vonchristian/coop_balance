module AccountingModule
  class Entry < ApplicationRecord
    include PgSearch
    pg_search_scope :text_search, :against => [:reference_number, :description]
    multisearchable against: [:reference_number, :description]
    enum entry_type: [:capital_build_up,
                      :deposit,
                      :withdrawal,
                      :loan_disbursement,
                      :supplier_payment,
                      :supplier_delivery,
                      :finished_good_entry,
                      :cash_sale,
                      :credit_sale,
                      :loan_payment,
                      :savings_interest,
                      :time_deposit,
                      :program_subscription_payment,
                      # :loan_penalty,
                      :time_deposit_interest,
                      :adjusting_entry,
                      :fund_transfer,
                      :share_capital_dividend,
                      :bank_deposit,
                      :bank_withdrawal,
                      :bank_earned_interest,
                      :bank_charge
                    ]

    has_one :clearance, class_name: "EntryClearance"
    belongs_to :commercial_document, :polymorphic => true
    belongs_to :recorder, foreign_key: 'recorder_id', class_name: "User"
    belongs_to :department
    belongs_to :branch
    belongs_to :voucher

    has_many :credit_amounts, :extend => AccountingModule::AmountsExtension, :class_name => 'AccountingModule::CreditAmount', :inverse_of => :entry, dependent: :destroy
    has_many :debit_amounts, :extend => AccountingModule::AmountsExtension, :class_name => 'AccountingModule::DebitAmount', :inverse_of => :entry, dependent: :destroy
    has_many :credit_accounts, :through => :credit_amounts, :source => :account, :class_name => 'AccountingModule::Account'
    has_many :debit_accounts, :through => :debit_amounts, :source => :account, :class_name => 'AccountingModule::Account'
    has_many :amounts, class_name: "AccountingModule::Amount"
    has_many :accounts, class_name: "AccountingModule::Account", through: :amounts
    validates :description, presence: true
    validate :has_credit_amounts?
    validate :has_debit_amounts?
    validate :amounts_cancel?

    accepts_nested_attributes_for :credit_amounts, :debit_amounts, allow_destroy: true



    before_save :set_default_date
    after_commit :update_accounts, :update_amounts

    delegate :first_and_last_name, to: :recorder, prefix: true, allow_nil: true
    delegate :number, to: :voucher, prefix: true, allow_nil: true

    def self.entered_on(hash={})
      if hash[:from_date] && hash[:to_date]
       from_date = hash[:from_date].kind_of?(DateTime) ? hash[:from_date] : Chronic.parse(hash[:from_date].strftime('%Y-%m-%d 12:00:00'))
        to_date = hash[:to_date].kind_of?(DateTime) ? hash[:to_date] : Chronic.parse(hash[:to_date].strftime('%Y-%m-%d 12:59:59'))
        includes([:amounts]).where('entries.entry_date' => (from_date.beginning_of_day)..(to_date.end_of_day))
      else
        all
      end
    end
    def self.recorded_by(recorder_id)
      where('recorder_id' => recorder_id )
    end
    def self.total(hash={})
      if hash[:from_date].present? && hash[:to_date].present?
        from_date = Chronic.parse(hash[:from_date].to_date)
        to_date = Chronic.parse(hash[:to_date].to_date)
        includes([:amounts]).where('entry_date' => from_date..to_date).distinct.map{|a| a.amounts.distinct.sum(:amount)}.sum
      else
        all.distinct.map{|a| a.credit_amounts.sum(:amount)}.sum
      end
    end
    def total
      debit_amounts.distinct.sum(:amount)
    end
    def cleared?
      clearance.present?
    end

    private
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
