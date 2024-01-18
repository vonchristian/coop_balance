require 'rails_helper'

module LoansModule
  describe LoanCreationProcessing do
    it '#create_loan' do
      voucher          = create(:voucher)
      user             = create(:teller)
      office           = user.office
      loan_product     = create(:loan_product)
      create(:office_loan_product, office: office, loan_product: loan_product)
      loan_application = create(:loan_application, voucher: voucher, office: office, number_of_days: 60, loan_product: loan_product)
      create(:loan_aging_group, office: office, start_num: 0, end_num: 0)

      described_class.new(loan_application: loan_application, employee: user).process!

      loan = LoansModule::Loan.find_by(account_number: loan_application.account_number)

      expect(loan).not_to eql nil
    end
  end
end
