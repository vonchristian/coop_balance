module CoopServicesModule
	class SavingProduct < ApplicationRecord
	  enum interest_recurrence: [:daily, :weekly, :monthly, :quarterly, :semi_annually, :annually]

	  has_many :subscribers, class_name: "MembershipsModule::Saving"
	  belongs_to :account, class_name: "AccountingModule::Account"
    belongs_to :closing_account, class_name: "AccountingModule::Account"
    belongs_to :interest_account, class_name: "AccountingModule::Account"


	  validates :interest_rate, :minimum_balance, numericality: { greater_than_or_equal_to: 0.01 }, presence: true
	  validates :interest_recurrence, presence: true
	  validates :name, presence: true, uniqueness: true
	  validates :account_id, :interest_account_id, presence: true

    delegate :name, to: :account, prefix: true
    def accounts_opened(options={})
      if options[:from_date] && options[:to_date]
        from_date = Chronic.parse(options[:from_date].to_date)
        to_date = Chronic.parse(options[:to_date].to_date)
        subscribers.where('created_at' => (from_date.beginning_of_day)..(to_date.end_of_day))
      else
        subscribers
      end
    end

    def self.total_subscribers
      all.map{|a| a.subscribers.count }.sum
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

    def balance(options={})
      account.balance(options)
    end

	  def post_interests_earned
      if quarterly?
  	  	post_quarterly_interests
      end
	  end
    def post_quarterly_interests
      subscribers.with_minimum_balances.each do |saving|
        InterestPosting.new.post_interests_earned(saving, Time.zone.now.end_of_quarter)
      end
    end
	end
end
