module CoopServicesModule
  class ShareCapitalProduct < ApplicationRecord
    extend Metricable
    extend Totalable
    extend VarianceMonitoring
    belongs_to :cooperative
    belongs_to :paid_up_account, class_name: "AccountingModule::Account"
    belongs_to :closing_account, class_name: "AccountingModule::Account"
    belongs_to :subscription_account, class_name: "AccountingModule::Account"
    belongs_to :interest_payable_account, class_name: "AccountingModule::Account"
    has_many :subscribers, class_name: "MembershipsModule::ShareCapital"

    validates :name,
              :paid_up_account_id,
              :closing_account_id,
              :subscription_account_id,
              :cost_per_share,
              presence: true
    validates :name, uniqueness: true
    validates :cost_per_share, numericality: true
    delegate :name, to: :paid_up_account, prefix: true
    delegate :name, to: :subscription_account, prefix: true

    def self.accounts
      accounts = self.pluck(:paid_up_account_id)
      AccountingModule::Account.where('accounts.id' => accounts)
    end

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
  end
end
