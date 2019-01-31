module LoansModule
  module Amortizers
    module PrincipalCalculators
      class EqualPayment
        attr_reader :schedule

        def initialize(args)
          @schedule         = args.fetch(:schedule)
        end

        def amortizeable_principal
          schedule.total_repayment - schedule.interest
        end
      end
    end
  end
end