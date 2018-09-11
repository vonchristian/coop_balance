class InterestAmortizationConfig < ApplicationRecord
  enum amortization_type: [:annually, :straight_balance]
end
