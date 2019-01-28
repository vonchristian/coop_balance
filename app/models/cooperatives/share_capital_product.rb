module Cooperatives
  class ShareCapitalProduct < ApplicationRecord
    extend Metricable
    extend Totalable
    extend VarianceMonitoring
    belongs_to :cooperative
    belongs_to :equity_account,      class_name: "AccountingModule::Account"
    belongs_to :interest_payable_account, class_name: "AccountingModule::Account"
    has_many :subscribers,            class_name: "MembershipsModule::ShareCapital"

    validates :name, :equity_account_id,
              :cost_per_share, presence: true
    validates :name, uniqueness: { scope: :cooperative_id }
    validates :cost_per_share, numericality: true
    delegate :name, to: :equity_account, prefix: true

    def self.accounts
      equity_accounts
    end

    def self.equity_accounts
      accounts = self.pluck(:equity_account_id)
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
