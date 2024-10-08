require 'rails_helper'

module LoansModule
  module InterestChargeSetters
    describe Prededucted do
      it '#create_charge!' do
        loan_product     = create(:loan_product)
        interest_config  = create(:add_on_interest_config, rate: 0.12, loan_product: loan_product)
        create(:interest_prededuction, calculation_type: 'percent_based', rate: 0.75, loan_product: loan_product)
        loan_application = create(:loan_application, loan_product: loan_product, loan_amount: 100_000)

        described_class.new(loan_application: loan_application).create_charge!

        expect(loan_application.voucher_amounts.credit.pluck(:account_id)).to include(interest_config.interest_revenue_account_id)
        expect(loan_application.voucher_amounts.credit.pluck(:description)).to include('Interest on Loan')
        expect(loan_application.voucher_amounts.credit.where(account: interest_config.interest_revenue_account).total).to be 9_000
      end
    end
  end
end
