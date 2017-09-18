module CoopConfigurationsModule
  class LoanPenaltyConfig < ApplicationRecord
    #Model to set configs for loan penalties

    validates :interest_rate, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
    validates :number_of_days, presence: true, numericality: true
  end
end
