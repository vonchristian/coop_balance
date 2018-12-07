module CoopServicesModule
  class ShareCapitalProduct < ApplicationRecord
    extend Metricable
    extend Totalable
    extend VarianceMonitoring
    belongs_to :cooperative
    belongs_to :paid_up_account,      class_name: "AccountingModule::Account"
    belongs_to :subscription_account, class_name: "AccountingModule::Account"
    has_many :subscribers,            class_name: "MembershipsModule::ShareCapital"

    validates :name, :paid_up_account_id, :subscription_account_id,
              :cost_per_share, presence: true
    validates :name, uniqueness: { scope: :cooperative_id }
    validates :cost_per_share, numericality: true
    delegate :name, to: :paid_up_account, prefix: true
    delegate :name, to: :subscription_account, prefix: true

    def self.accounts
      paid_up_accounts
    end

    def self.paid_up_accounts
      accounts = self.pluck(:paid_up_account_id)
      AccountingModule::Account.where(id: accounts)
    end

    def self.subscription_accounts
      accounts = self.pluck(:subscription_account_id)
      AccountingModule::Account.where(id: accounts)
    end

    def self.default_product
      where(default_product: true).last
    end

    def minimum_balance
      cost_per_share * minimum_number_of_paid_share
    end
  end
end
