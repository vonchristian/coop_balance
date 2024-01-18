module LoansModule
  module Loans
    module Amortization
      def amortized_principal_for(options = {})
        amortization_schedules.scheduled_for(options).sum(&:principal)
      end

      def amortized_interest_for(options = {})
        amortization_schedules.scheduled_for(options).sum(&:interest)
      end
    end
  end
end
