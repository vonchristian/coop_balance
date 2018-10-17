module CoopServicesModule
	class TimeDepositProduct < ApplicationRecord
    extend Totalable
    extend Metricable
    extend VarianceMonitoring

    belongs_to :cooperative
    belongs_to :account, class_name: "AccountingModule::Account"
    belongs_to :interest_expense_account, class_name: "AccountingModule::Account"
    belongs_to :break_contract_account, class_name: "AccountingModule::Account"

    delegate :name, to: :account, prefix: true

    validates :account_id,
              :interest_expense_account_id,
              :break_contract_account_id,
              :name,
              :minimum_deposit,
              :maximum_deposit,
              :interest_rate,
              :break_contract_fee,
              :break_contract_rate,
              :time_deposit_product_type,
              :cooperative_id,
              presence: true
    validates :break_contract_fee,
              :break_contract_rate,
              :minimum_deposit,
              :maximum_deposit,
              :interest_rate,
              numericality: true
    validates :name,
              uniqueness: true
    def self.accounts
      ids = all.pluck(:account_id)
      AccountingModule::Account.where(id: ids)
    end
    def self.total_balance(args={})
      accounts.balance(args)
    end

    def self.total_debits_balance(args={})
      accounts.debits_balance(args)
    end

    def self.total_credits_balance(args={})
      accounts.credits_balance(args)
    end

    def amount_range
      minimum_deposit..maximum_deposit
    end

    def amount_range_and_days
      "#{name} - #{amount_range} #{number_of_days} days"
    end

    def monthly_interest_rate
      months = number_of_days / 30
      interest_rate / months
    end
	end
end
