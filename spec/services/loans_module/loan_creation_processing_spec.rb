require 'rails_helper'

module LoansModule
  describe LoanCreationProcessing do 
    it "#create_loan" do 
      voucher          = create(:voucher)
      user             = create(:teller)
      office           = user.office 
      loan_application = create(:loan_application, voucher: voucher, office: office)
      loan_aging_group = create(:loan_aging_group, office: office)

      described_class.new(loan_application: loan_application, employee: user).process!

      loan = LoansModule::Loan.find_by(account_number: loan_application.account_number)

      expect(loan).to_not eql nil 
    end
  end
end