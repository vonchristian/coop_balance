require 'rails_helper'

module LoansModule
  module ChargeSetters
    describe PercentBasedStraightLine do
      it "#create_charges!" do
        loan_product          = create(:loan_product)
        interest_config       = create(:prededucted_interest_config, rate: 0.12, loan_product: loan_product)
        interest_prededuction = create(:percent_based_interest_prededuction, rate: 0.75,  loan_product: loan_product)
        loan_application      = create(:loan_application, loan_product: loan_product, loan_amount: 100_000)

        described_class.new(loan_application: loan_application).create_charges!
        
        expect(loan_application.voucher_amounts.credit.pluck(:account_id)).to include(interest_config.interest_revenue_account_id)
        expect(loan_application.voucher_amounts.credit.pluck(:description)).to include("Interest on Loan")
        expect(loan_application.voucher_amounts.credit.where(account: interest_config.interest_revenue_account).total).to eql 9_000
      end
    end
  end
end
