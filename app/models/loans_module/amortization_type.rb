module LoansModule
  class AmortizationType < ApplicationRecord
    enum calculation_type: [:straight_line, :declining_balance]

    validates :calculation_type, presence: true


  end
end
