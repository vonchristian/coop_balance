module CoopServicesModule
  class TimeDepositProduct < ApplicationRecord
    extend Totalable
    extend Metricable
    extend VarianceMonitoring

    belongs_to :cooperative

    delegate :name, to: :account, prefix: true

    validates :name,
              :minimum_deposit,
              :maximum_deposit,
              :interest_rate,
              :break_contract_fee,
              :break_contract_rate,
              presence: true
    validates :break_contract_fee,
              :break_contract_rate,
              :minimum_deposit,
              :maximum_deposit,
              :interest_rate,
              numericality: true
    validates :name,
              uniqueness: true

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
