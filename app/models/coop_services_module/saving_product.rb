 module CoopServicesModule
	class SavingProduct < ApplicationRecord
	  enum interest_recurrence: [:daily, :weekly, :monthly, :quarterly, :semi_annually, :annually]

	  has_many :subscribers, class_name: "MembershipsModule::Saving"
	  belongs_to :account, class_name: "AccountingModule::Account"
    belongs_to :closing_account, class_name: "AccountingModule::Account"
    belongs_to :interest_expense_account, class_name: "AccountingModule::Account"

	  validates :interest_rate, :minimum_balance, numericality: { greater_than_or_equal_to: 0.01 }, presence: true
	  validates :interest_recurrence, presence: true
	  validates :name, presence: true, uniqueness: true
	  validates :account_id, :interest_expense_account_id, :closing_account_id, presence: true

    delegate :name, to: :account, prefix: true
    delegate :balance, :debits_balance, :credits_balance, to: :account

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
    	all.map{|a| a.account }
    end

    def self.accounts_balance(options={})
      accounts.uniq.map{|a| a.balance(options)}.sum
    end
    def self.accounts_credits_balance(options={})
      accounts.uniq.map{|a| a.credits_balance(options)}.sum
    end

    def self.accounts_debits_balance(options={})
      accounts.uniq.map{|a| a.debits_balance(options)}.sum
    end

    def interest_posted?(date)
      interest_expense_account.credit_amounts.entered_on(from_date: beginning_date_for(date), to_date: ending_date_for(date)).present?
    end

	  def post_interests_earned
      if quarterly?
  	  	post_quarterly_interests
      end
	  end

    private

    def post_quarterly_interests
      subscribers.with_minimum_balances.each do |saving|
        if !saving.interest_posted?(Time.zone.now.end_of_quarter)
          InterestPosting.new.post_interests_earned(saving, Time.zone.now.end_of_quarter)
        end
      end
    end

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
