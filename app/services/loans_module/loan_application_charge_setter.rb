module LoansModule
  class LoanApplicationChargeSetter
    attr_reader :loan_application, :loan_product

    def initialize(args)
      @loan_application = args.fetch(:loan_application)
      @loan_product     = @loan_application.loan_product

    end
    def create_charges!
      create_interest_on_loan_charge
      create_percent_based_charges
      # create_amount_based_charges
      # create_loan_protection_fund
    end

    private
    def create_interest_on_loan_charge
      loan_application.voucher_amounts.create!(
        description: "Interest on Loan",
        amount: loan_application.prededucted_interest,
        account: loan_product.current_interest_config_interest_revenue_account
      )
    end
    def create_percent_based_charges
      loan_product.loan_product_charges.percent_based.each do |charge|
        loan_application.voucher_amounts.create!(
          description: charge.name,
          amount: charge.charge_amount(loan_application.loan_amount),
          account: charge.account
        )
      end
    end
  end
end
