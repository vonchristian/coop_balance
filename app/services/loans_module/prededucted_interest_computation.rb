class InterestComputation
  attr_reader :loan_application, :interest_config

  def initialize(args)
    @loan_application = args.fetch(:loan_application)
    @loan_product     = @loan_application.loan_product
    @interest_config  = @loan_product.current_interest_config
  end
  def compute_interest
    loan_application.loan_amount * interest_config.applicable_rate
  end
end
