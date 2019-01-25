module LoansModule
  class AmortizationType < ApplicationRecord
    enum calculation_type: [:straight_line, :declining_balance]

    validates :calculation_type, presence: true

    def amortizer
      ("LoansModule::Amortizers::" + calculation_type.titleize.gsub(" ", "")).constantize
    end
  end
end
