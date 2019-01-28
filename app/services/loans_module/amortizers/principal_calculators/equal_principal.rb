module LoansModule
  module Amortizers
    module PrincipalCalculators
      class EqualPrincipal
        attr_reader :loan_application

        def initialize(args)
          @loan_application = args.fetch(:loan_application)
        end

        def amortizeable_principal
          (loan_application.loan_amount.amount / loan_application.schedule_count)
        end
      end
    end
  end
end
