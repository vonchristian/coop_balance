module LoansModule
  class LoanApplicationChargeSetter
    attr_reader :loan_application, :loan_product

    def initialize(args)
      @loan_application = args.fetch(:loan_application)
      @loan_product     = @loan_application.loan_product
    end

    def create_charges!
      create_interest_on_loan_charge
      create_charges
      create_loan_protection_fund
    end

    private
    def create_interest_on_loan_charge
      loan_application.voucher_amounts.create!(
        amount_type: 'credit',
        cooperative: loan_application.cooperative,
        description: "Interest on Loan",
        amount:      interest_amount,
        account:     interest_account
      )
    end

    def create_charges
      loan_product.loan_product_charges.each do |charge|
        loan_application.voucher_amounts.credit.create!(
          cooperative: loan_application.cooperative,
          description: charge.name,
          amount: charge.charge_amount(chargeable_amount: loan_application.loan_amount.amount),
          account: charge.account
        )
      end
    end

    def create_loan_protection_fund
      if loan_product.loan_protection_plan_provider.present?
        loan_application.voucher_amounts.credit.create!(
        cooperative: loan_application.cooperative,
        amount: loan_product.loan_protection_plan_provider.amount_for(loan),
        account: loan_product.loan_protection_plan_provider.accounts_payable,
        description: 'Loan Protection Fund'
        )
      end
    end

    def interest_amount
      if loan_product.current_interest_config.add_on?
        loan_application.add_on_interest
      elsif loan_product.current_interest_config.prededucted?
        loan_application.prededucted_interest
      end
    end

    def interest_account
      if loan_product.current_interest_config.add_on?
        loan_product.current_interest_config_unearned_interest_income_account
      elsif loan_product.current_interest_config.prededucted?
        loan_product.current_interest_config_revenue_account
      end
    end
  end
end
