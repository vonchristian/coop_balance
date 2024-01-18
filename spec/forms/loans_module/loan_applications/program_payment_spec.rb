require 'rails_helper'

module LoansModule
  module LoanApplications
    describe ProgramPayment do
      describe 'validations', type: :model do
        it { should validate_presence_of :loan_application_id }
        it { should validate_presence_of :program_id }
        it { should validate_presence_of :amount }
      end

      it '#process!' do
        loan_application = create(:loan_application)
        program          = create(:program)

        described_class.new(
          loan_application_id: loan_application.id,
          program_id: program.id,
          amount: 500
        ).process!

        voucher_amount = loan_application.voucher_amounts.where(account: program.account).last

        expect(voucher_amount.description).to eq program.name
        expect(voucher_amount.account).to eq program.account
        expect(voucher_amount.amount.amount).to eq 500
        expect(voucher_amount.amount_type).to eql 'credit'
      end
    end
  end
end
