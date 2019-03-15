 module CoopServicesModule
	class SavingProduct < ApplicationRecord
    extend Totalable
    extend Metricable
    extend VarianceMonitoring
	  enum interest_recurrence: [:daily, :weekly, :monthly, :quarterly, :semi_annually, :annually]

    belongs_to :cooperative
    belongs_to :office,                   class_name: "Cooperatives::Office"
	  belongs_to :account,                  class_name: "AccountingModule::Account"
    belongs_to :closing_account,          class_name: "AccountingModule::Account"
    belongs_to :interest_expense_account, class_name: "AccountingModule::Account"

    has_many :subscribers,                class_name: "MembershipsModule::Saving"

	  validates :interest_rate,
              :minimum_balance,
              numericality: { greater_than_or_equal_to: 0.01 },
              presence: true
	  validates :interest_recurrence,
              presence: true
	  validates :name,
              presence: true,
              uniqueness: { scope: :office_id }
	  validates :account_id,
              :interest_expense_account_id,
              :closing_account_id,
              presence: true
    validates :cooperative_id, presence: true
    validates :minimum_balance, presence: true, numericality: true

    delegate :name, to: :account, prefix: true
    delegate :balance,
             :debits_balance,
             :credits_balance, to: :account

    def self.accounts_opened(args={})
      SavingProductQuery.new.accounts_opened(args)
    end

    def self.total_subscribers
      sum(&:total_subscribers)
    end

    def total_subscribers
      subscribers.count
    end

    def interest_earned_posting_status_finder
      ("SavingsModule::InterestEarnedPostingStatusFinders::" + interest_recurrence.titleize.gsub(" ", "")).constantize
    end

    def balance_averager
      ("SavingsModule::BalanceAveragers::" + interest_recurrence.titleize.gsub(" ", "")).constantize
    end
    def compute_interest(amount)
      applicable_rate.to_f * amount
    end

    def self.accounts
      accounts = self.pluck(:account_id)
      AccountingModule::Account.where('accounts.id' => accounts)
    end

    def applicable_rate
      interest_rate  / rate_divisor
    end

    def rate_divisor
      applicable_divisor.new(saving_product: self).rate_divisor
    end

    def applicable_divisor
      ("SavingsModule::InterestRateDivisors::" + interest_recurrence.titleize.gsub(" ", "")).constantize
    end

    def date_setter
      ("SavingsModule::DateSetters::" + interest_recurrence.titleize.gsub(" ", "")).constantize
    end

    def interest_posted?(args={})
      interest_expense_account.
      credit_amounts.
      entries_for(commercial_document: self).
      entered_on(
        from_date: beginning_date_for(args[:date]),
        to_date: ending_date_for(args[:date])).present?
    end
	end
end
