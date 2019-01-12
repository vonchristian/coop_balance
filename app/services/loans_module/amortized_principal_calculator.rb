module LoansModule
  class AmortizedPrincipalCalculator
    attr_reader :loan_application

    def initialize(args)
      @loan_application = args.fetch(:loan_application)
    end
    
  end
end
