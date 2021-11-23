module LoansModule
  class LoanApplicationAmountUpdater
    attr_reader :loan_application, :interest_config, :loan_product

    def initialize(args)
      @loan_application = args.fetch(:loan_application)
      @loan_product     = @loan_application.loan_product
      @interest_config  = @loan_product.current_interest_config
    end

    def update_amount!
      if !interest_config.prededucted?
        loan_application.update(loan_amount: updated_loan_amount)
      end
    end

    private
    def updated_loan_amount
      loan_application.loan_amount.amount + computed_add_on_interest
    end

    def computed_add_on_interest
      loan_application.add_on_interest
    end
  end
end
