module CoopServicesModule
  class ShareCapitalProduct < ApplicationRecord
    belongs_to :account, class_name: "AccountingModule::Account"
    has_many :share_capital_product_shares
    has_many :subscribers, class_name: "MembershipsModule::ShareCapital"

    validates :name, :account_id, :cost_per_share, presence: true
    validates :name, uniqueness: true
    validates :cost_per_share, numericality: true
    delegate :name, to: :account, prefix: true

    def self.accounts
      all.map{|a| a.account_name }
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

    def credit_account
      if name== "Share Capital - Common"
        AccountingModule::Account.find_by(name: "Paid-up Share Capital - Common")
      elsif name == "Share Capital - Preferred"
        AccountingModule::Account.find_by(name: "Paid-up Share Capital - Preferred")
      end
    end
  end
end
