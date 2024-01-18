module LoansModule
  class LoanApplicationChargeSetter
    attr_reader :loan_application, :loan_product, :borrower

    def initialize(args)
      @loan_application = args.fetch(:loan_application)
      @loan_product     = @loan_application.loan_product
      @borrower         = @loan_application.borrower
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
      loan_product.loan_product_charges.except_capital_build_up.each do |charge|
        loan_application.voucher_amounts.credit.create!(
          cooperative: loan_application.cooperative,
          description: charge.name,
          amount: computed_charge(charge, loan_application.loan_amount),
          account: charge.account
        )
      end
    end

    def create_loan_protection_fund
      return if loan_product.loan_protection_plan_provider.blank?

      loan_application.voucher_amounts.credit.create!(
        cooperative: loan_application.cooperative,
        amount: loan_product.loan_protection_plan_provider.amount_for(loan_application),
        account: loan_product.loan_protection_plan_provider.accounts_payable,
        description: 'Loan Protection Fund'
      )
    end

    def create_capital_build_up
      return if borrower.share_capitals.blank?

      LoansModule::Charges::CapitalBuildUp.new(loan_application: loan_application).create_capital_build_up
    end

    def computed_charge(charge, _amount)
      charge.charge_amount(chargeable_amount: loan_application.loan_amount.amount)
    end
  end
end
