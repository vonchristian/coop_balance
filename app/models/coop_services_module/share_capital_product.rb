module CoopServicesModule
  class ShareCapitalProduct < ApplicationRecord
    belongs_to :account, class_name: "AccountingModule::Account"
    has_many :share_capital_product_shares
    has_many :subscribers, class_name: "MembershipsModule::ShareCapital"

    validates :name, :account_id, :cost_per_share, presence: true
    validates :name, uniqueness: true
    validates :cost_per_share, numericality: true
    delegate :name, to: :account, prefix: true
    def self.set_product_for(share_capital)
    end
    def default_account
      if account.present?
        account
      else
        AccountingModule::Account.find_by(name: "Paid-up Share Capital - Common")
      end
    end

    def self.accounts
      all.map{|a| a.account }
    end

    def self.accounts_balance(options={})
      accounts.uniq.map{|a| a.balance(options)}.sum
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
