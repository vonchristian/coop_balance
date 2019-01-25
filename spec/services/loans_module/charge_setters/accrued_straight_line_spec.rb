require 'rails_helper'

module LoansModule
  module ChargeSetters
    describe AccruedStraightLine do
      it "#create_accrued_interest" do
        loan_product     = create(:loan_product)
        interest_config  = create(:accrued_interest_config, rate: 0.12, loan_product: loan_product)
        loan_application = create(:loan_application, loan_product: loan_product, loan_amount: 100_000)

        described_class.new(loan_application: loan_application).create_charges!

        expect(loan_application.voucher_amounts.pluck(:account_id)).to include(interest_config.accrued_income_account_id)
        expect(loan_application.voucher_amounts.pluck(:description)).to include("Accrued Interest Income")
        expect(loan_application.voucher_amounts.where(account: interest_config.accrued_income_account).total).to eql 12_000
      end
    end
  end
end
