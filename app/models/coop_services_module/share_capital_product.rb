module CoopServicesModule
  class ShareCapitalProduct < ApplicationRecord
    belongs_to :paid_up_account, class_name: "AccountingModule::Account"
    belongs_to :closing_account, class_name: "AccountingModule::Account"
    belongs_to :subscription_account, class_name: "AccountingModule::Account"

    has_many :share_capital_product_shares
    has_many :subscribers, class_name: "MembershipsModule::ShareCapital"

    validates :name, :paid_up_account_id, :closing_account_id, :subscription_account_id, :cost_per_share, presence: true
    validates :name, uniqueness: true
    validates :cost_per_share, numericality: true
    delegate :name, to: :paid_up_account, prefix: true
    delegate :name, to: :subscription_account, prefix: true


    def self.subscribe(subscriber)
      subscriber.share_capitals.find_or_create_by(share_capital_product: self.default_product)
    end
    def minimum_payment
      cost_per_share * minimum_number_of_paid_share
    end
    def self.default_product
      where(default_product: true).last
    end
    def default_paid_up_account
      if paid_up_account.present?
        paid_up_account
      else
        AccountingModule::Account.find_by(name: "Paid-up Share Capital - Common")
      end
    end
    def default_subscription_account
      if subscription_account.present?
        subscription_account
      else
        AccountingModule::Account.find_by(name: "Subscribed Share Capital - Common")
      end
    end

    def self.paid_up_accounts
      all.map{|a| a.paid_up_account }
    end

    def self.subscription_accounts
      all.map{|a| a.subscription_account }
    end

    def self.paid_up_accounts_balance(options={})
      paid_up_accounts.uniq.map{|a| a.balance(options)}.sum
    end
    def self.subscription_accounts_balance(options={})
      subscription_accounts.uniq.map{|a| a.balance(options)}.sum
    end
    def self.paid_up_accounts_credits_balance(options={})
      paid_up_accounts.uniq.map{|a| a.credits_balance(options)}.sum
    end
    def self.subscription_accounts_credits_balance(options={})
      subscription_accounts.uniq.map{|a| a.credits_balance(options)}.sum
    end
    def self.paid_up_accounts_debits_balance(options={})
      paid_up_accounts.uniq.map{|a| a.debits_balance(options)}.sum
    end
    def self.subscription_accounts_debits_balance(options={})
      subscription_accounts.uniq.map{|a| a.debits_balance(options)}.sum
    end

    def total_subscribed
      subscribers.subscribed_shares
    end

    def total_available_shares
      total_shares - total_subscribed
    end

    def total_shares
      share_capital_product_shares.total_shares
    end
  end
end
