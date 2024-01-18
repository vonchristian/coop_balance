require 'rails_helper'

module LoansModule
  module LoanApplications
    describe Disbursement, type: :model do
      describe 'validations' do
        it { should validate_presence_of :loan_application_id }
        it { should validate_presence_of :employee_id }
        it { should validate_presence_of :disbursement_date }
      end

      it '#disburse!' do
        teller             = create(:teller)

        receivable_account = create(:asset)
        cash_account       = create(:asset)
        voucher            = create(:voucher, entry_id: nil, disbursement_date: Date.current)
        create(:voucher_amount, amount: 100, amount_type: 'credit', account: cash_account, voucher: voucher)
        create(:voucher_amount, amount: 100, amount_type: 'debit', account: receivable_account, voucher: voucher)
        loan_application = create(:loan_application, voucher: voucher, receivable_account: receivable_account, office: teller.office)
        create(:loan_aging_group, office: teller.office)
        puts voucher.inspect
        puts ''
        puts loan_application.voucher.inspect

        described_class.new(
          disbursement_date: Date.current.end_of_month,
          loan_application_id: loan_application.id,
          employee_id: teller.id
        ).disburse!

        # expect(voucher.disbursement_date).to eq Date.current.end_of_month
        expect(loan_application.loan).not_to eql nil
        AccountingModule::Entry.find_by!(reference_number: voucher.reference_number)
        puts voucher.inspect
      end
    end
  end
end
