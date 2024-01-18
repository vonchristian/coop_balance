require 'rails_helper'

module LoansModule
  module LoanApplications
    describe PreviousLoanPaymentProcessing, type: :model do
      describe 'validations' do
        it { should validate_presence_of :principal_amount }
        it { should validate_presence_of :loan_application_id }
        it { should validate_presence_of :loan_id }

        it { should validate_numericality_of :principal_amount }
        it { should validate_numericality_of :interest_amount }
        it { should validate_numericality_of :penalty_amount }
      end

      it '#process!' do
        borrower         = create(:member)
        loan_application = create(:loan_application, borrower: borrower)
        loan             = create(:loan, borrower: borrower)

        described_class.new(
          loan_id: loan.id,
          loan_application_id: loan_application.id,
          principal_amount: 100,
          interest_amount: 100,
          penalty_amount: 100
        ).process!

        principal = loan_application.voucher_amounts.where(account: loan.receivable_account).last
        interest  = loan_application.voucher_amounts.where(account: loan.interest_revenue_account).last
        penalty   = loan_application.voucher_amounts.where(account: loan.penalty_revenue_account).last

        expect(principal.account).to eql loan.receivable_account
        expect(principal.amount.amount).to be 100
        expect(principal.description).to eq 'Previous Loan Payment (Principal)'
        expect(principal.amount_type).to eq 'credit'

        expect(interest.account).to eql loan.interest_revenue_account
        expect(interest.amount.amount).to be 100
        expect(interest.description).to eq 'Previous Loan Payment (Interest)'
        expect(interest.amount_type).to eq 'credit'

        expect(penalty.account).to eql loan.penalty_revenue_account
        expect(penalty.amount.amount).to be 100
        expect(penalty.description).to eq 'Previous Loan Payment (Penalty)'
        expect(penalty.amount_type).to eq 'credit'
      end
    end
  end
end
