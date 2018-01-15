require 'rails_helper'

module LoansModule
  describe PreviousLoanPaymentForm, type: :model do
    describe 'validations' do
      it { is_expected.to validate_presence_of :principal_amount }
      it { is_expected.to validate_numericality_of :principal_amount }
    end

    it "#create_loan_charges" do
      loan = create(:loan, loan_amount: 10_000)
      previous_loan = create(:loan, loan_amount: 5_000)
    end
  end
end
