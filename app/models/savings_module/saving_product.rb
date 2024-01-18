 module SavingsModule
	class SavingProduct < ApplicationRecord
    extend Totalable
    extend Metricable
    extend VarianceMonitoring

    has_one :saving_product_interest_config, class_name: 'SavingsModule::SavingProducts::SavingProductInterestConfig'
    belongs_to :cooperative
    belongs_to :office,                   class_name: "Cooperatives::Office"
    belongs_to :closing_account,          class_name: "AccountingModule::Account"
    has_many :subscribers,                class_name: "DepositsModule::Saving"

	  validates :interest_rate,
              :minimum_balance,
              numericality: { greater_than_or_equal_to: 0.01 },
              presence: true
	  validates :interest_recurrence,
              presence: true
	  validates :name,
              presence: true,
              uniqueness: { scope: :office_id }

    validates :cooperative_id, presence: true
    validates :minimum_balance, presence: true, numericality: true

    def self.accounts_opened(args={})
      SavingProductQuery.new.accounts_opened(args)
    end

    def self.total_subscribers
      sum(&:total_subscribers)
    end

    def total_subscribers
      subscribers.size
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
      accounts = []
      self.all.each do |saving_product|
        accounts << saving_product.subscribers.pluck(:liability_account_id)
      end
        AccountingModule::Account.where('accounts.id' => accounts.uniq.compact.flatten)
    end

    def applicable_rate
      interest_rate  / rate_divisor
    end

    def rate_divisor
      applicable_divisor.new(saving_product: self).rate_divisor
    end

    def applicable_rate
      ("SavingsModule::InterestRateSetters::" + interest_recurrence.titleize.gsub(" ", "")).constantize
    end

    def date_setter
      ("SavingsModule::DateSetters::" + interest_recurrence.titleize.gsub(" ", "")).constantize
    end
	end
end
