require 'rails_helper'

module LoansModule
  module LoanApplications 
    describe NetProceedCalculator do 

      it "#net_proceed" do 
        cart          = create(:cart)
        loan_application = create(:loan_application, loan_amount: 100_000, cart: cart)
        create(:voucher_amount, amount_type: 'credit', amount: 12_000, account: loan_application.interest_revenue_account, cart: cart)

        expect(described_class.new(loan_application: loan_application).net_proceed).to eql 88_000
      end 
    end 
  end 
end 
