require 'rails_helper'

module LoansModule
  module LoanApplications
    describe SavingsAccountDepositProcessing do
      it '#process!' do
        member = create(:member)
        loan_application = create(:loan_application, borrower: member)
        savings_account  = create(:saving, depositor: member)

        described_class.new(
          amount: 100,
          loan_application_id: loan_application.id,
          savings_account_id: savings_account.id
        )
                       .process!

        voucher_amount = loan_application.voucher_amounts.where(account_id: savings_account.liability_account_id).last

        expect(voucher_amount.amount.amount).to be 100
        expect(voucher_amount.account).to eql savings_account.liability_account
        expect(voucher_amount.description).to eql 'Savings Deposit'
      end
    end
  end
end