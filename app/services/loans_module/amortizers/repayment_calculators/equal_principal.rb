module LoansModule
  module Amortizers
    module RepaymentCalculators
      class EqualPrincipal
        attr_reader :loan_application, :schedule

        def initialize(args = {})
          @loan_application = args.fetch(:loan_application)
        end

        def total_repayment
          schedule.principal + schedule.interest
        end
      end
    end
  end
end
