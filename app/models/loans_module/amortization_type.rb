module LoansModule
  class AmortizationType < ApplicationRecord
    enum calculation_type: [:straight_line, :declining_balance]
  end
end
