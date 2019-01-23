 module CoopServicesModule
	class SavingProduct < ApplicationRecord
    extend Totalable
    extend Metricable
    extend VarianceMonitoring
	  enum interest_recurrence: [:daily, :weekly, :monthly, :quarterly, :semi_annually, :annually]

    belongs_to :cooperative
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
              uniqueness: { scope: :cooperative_id }
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

    def balance_averager
      ("SavingsModule::BalanceAveragers::" + interest_recurrence.titleize.gsub(" ", "")).constantize
    end

    def self.accounts
      accounts = self.pluck(:account_id)
      AccountingModule::Account.where('accounts.id' => accounts)
    end
    def applicable_rate
      interest_rate  / rate_divisor
    end

    def rate_divisor
      if daily?
        364
      elsif monthly?
        12.0
      elsif quarterly?
        4.0
      elsif semi_annually?
        2.0
      elsif annually?
        1.0
      end
    end

    # def starting_date(date)
    #   if daily?
    #     date.beginning_of_day
    #   elsif monthly?
    #     date.beginning_of_month
    #   elsif quarterly?
    #     date.beginning_of_quarter
    #   elsif annually?
    #     date.beginning_of_year
    #   end
    # end
    #
    # def ending_date(date)
    #   if daily?
    #     date.end_of_day
    #   elsif monthly?
    #     date.end_of_month
    #   elsif quarterly?
    #     date.end_of_quarter
    #   elsif annually?
    #     date.end_of_year
    #   end
    # end


    def interest_posted?(args={})
      interest_expense_account.
      credit_amounts.
      entries_for(commercial_document: self).
      entered_on(
        from_date: beginning_date_for(args[:date]),
        to_date: ending_date_for(args[:date])).present?
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
