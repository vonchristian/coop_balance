require 'rails_helper'

module LoansModule
  describe LoanApplicationAmountUpdater do
    # add_on_interest
    let!(:loan_product_1)     { create(:loan_product) }
    let!(:interest_config_1)  { create(:add_on_interest_config, rate: 0.25, loan_product: loan_product_1) }
    let!(:loan_application_1) { create(:loan_application, loan_amount: 4_720, loan_product: loan_product_1) }

    # prededucted_interest
    let!(:loan_product_2)     { create(:loan_product) }
    let!(:interest_config_2)  { create(:prededucted_interest_config, rate: 0.25, loan_product: loan_product_2) }
    let!(:loan_application_2) { create(:loan_application, loan_amount: 4_720, loan_product: loan_product_2) }

    before do
      described_class.new(loan_application: loan_application_1).update_amount!
      described_class.new(loan_application: loan_application_2).update_amount!
    end

    it '#update_amount!' do
      expect(loan_application_1.loan_amount.amount).to be 5_900
      expect(loan_application_2.loan_amount.amount).to be 4720
    end
  end
end
