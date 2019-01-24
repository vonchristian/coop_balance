require 'rails_helper'

describe LoanProductInterestCalculation do
  describe 'payment_procesor' do
    it "add_on" do
      interest_calculation = create(:loan_product_interest_calculation, calculation_type: 'add_on')
      expect(interest_calculation.payment_processor).to eql LoansModule::PaymentProcessors::AddOnInterest
    end

    it "prededucted" do
      interest_calculation = create(:loan_product_interest_calculation, calculation_type: 'prededucted')
      expect(interest_calculation.payment_processor).to eql LoansModule::PaymentProcessors::PredeductedInterest
    end

    it "unearned" do
      interest_calculation = create(:loan_product_interest_calculation, calculation_type: 'unearned')
      expect(interest_calculation.payment_processor).to eql LoansModule::PaymentProcessors::UnearnedInterest
    end
  end
end
