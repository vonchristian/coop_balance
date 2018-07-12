 module CoopServicesModule
	class SavingProduct < ApplicationRecord
    extend Totalable
    extend Metricable
	  enum interest_recurrence: [:daily, :weekly, :monthly, :quarterly, :semi_annually, :annually]

	  has_many :subscribers,                class_name: "MembershipsModule::Saving"
	  belongs_to :account,                  class_name: "AccountingModule::Account"
    belongs_to :closing_account,          class_name: "AccountingModule::Account"
    belongs_to :interest_expense_account, class_name: "AccountingModule::Account"

	  validates :interest_rate,
              :minimum_balance,
              numericality: { greater_than_or_equal_to: 0.01 },
              presence: true
	  validates :interest_recurrence,
              presence: true
	  validates :name,
              presence: true,
              uniqueness: true
	  validates :account_id,
              :interest_expense_account_id,
              :closing_account_id,
              presence: true

    validates :minimum_balance, presence: true, numericality: true

    delegate :name, to: :account, prefix: true
    delegate :balance,
             :debits_balance,
             :credits_balance, to: :account

    def self.total_balance(args={})
      accounts.balance(args)
    end

    def self.accounts_opened(options={})
      SavingProductQuery.new.accounts_opened(options)
    end

    def self.total_subscribers
      sum(&:total_subscribers)
    end

    def total_subscribers
      subscribers.count
    end

    def self.accounts
      accounts = self.pluck(:account_id)
      AccountingModule::Account.where('accounts.id' => accounts)
    end

    def interest_posted?(options={})
      interest_expense_account.
      credit_amounts.
      entries_for(commercial_document: self).
      entered_on(
        from_date: beginning_date_for(options[:date]),
        to_date: ending_date_for(options[:date])).present?
    end

    def quarterly_interest_rate
      interest_rate / 4.0
    end

    private
    def beginning_date_for(date)
      if quarterly?
        date.beginning_of_quarter
      end
    end

    def ending_date_for(date)
      if quarterly?
        date.end_of_quarter
      end
    end
	end
end
