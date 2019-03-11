module LoansModule
  class LoanApplicationChargeSetter
    attr_reader :loan_application, :loan_product

    def initialize(args)
      @loan_application = args.fetch(:loan_application)
      @loan_product     = @loan_application.loan_product
    end

    def create_charges!
      create_interest_on_loan_charge
      create_charges_based_on_loan_product
      create_capital_build_up
      create_loan_protection_fund
    end

    private

    def create_interest_on_loan_charge
      loan_product.interest_charge_setter.new(loan_application: loan_application).create_charge!
    end

    def create_charges_based_on_loan_product
      loan_product.loan_product_charges.each do |charge|
        loan_application.voucher_amounts.credit.create!(
          cooperative:         loan_application.cooperative,
          commercial_document: loan_application,
          description:         charge.name,
          amount:              computed_charge(charge, loan_application.loan_amount),
          account:             charge.account
        )
      end
    end

    def create_loan_protection_fund
      if loan_product.loan_protection_plan_provider.present?
        loan_application.voucher_amounts.credit.create!(
        commercial_document: loan_application,
        cooperative: loan_application.cooperative,
        amount: loan_product.loan_protection_plan_provider.amount_for(loan_application),
        account: loan_product.loan_protection_plan_provider.accounts_payable,
        description: 'Loan Protection Fund'
        )
      end
    end

    def create_capital_build_up
      if loan_application.loan_product_name == "Regular Loan"
        loan_application.voucher_amounts.credit.create!(
          cooperative:         loan_application.cooperative,
          commercial_document: loan_application.borrower.share_capitals.last,
          description:         "Capital Build Up",
          amount:              capital_build_up_computation,
          account:             loan_application.borrower.share_capitals.last.share_capital_product.equity_account
        )
      end
    end

    def capital_build_up_computation
      loan_application.loan_amount.amount * 0.01
    end

    def computed_charge(charge, amount)
      charge.charge_amount(chargeable_amount: loan_application.loan_amount.amount)
    end
  end
end
