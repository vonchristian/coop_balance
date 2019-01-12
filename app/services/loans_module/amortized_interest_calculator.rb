module LoansModule
  class AmortizedInterestCalculator
    attr_reader :loan_application, :interest_config

    def initialize(args)
      @loan_application      = args.fetch(:loan_application)
      @interest_config = args.fetch(:interest_config)
    end

    def compute
      if interest_config.
      loan_application.interest_balance / term
