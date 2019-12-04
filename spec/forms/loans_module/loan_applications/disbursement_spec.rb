require 'rails_helper'

module LoansModule
  module LoanApplications
    describe Disbursement do
      it "disburse!" do
        cash             = create(:asset)
        teller           = create(:teller)
        voucher          = create(:voucher, entry_id: nil, disbursement_date: Date.current)
        loan_application = create(:loan_application, voucher: voucher, office: teller.office)
        voucher_amount_1 = create(:voucher_amount, amount_type: 'debit', amount: 100,  account: loan_application.receivable_account, voucher: voucher)
        voucher_amount_2 = create(:voucher_amount, amount_type: 'credit', amount: 100,  account: cash, voucher: voucher)
        loan_aging_group = create(:loan_aging_group, office: teller.office)

        disbursement = described_class.new(
          loan_application_id: loan_application.id,
          employee_id:         teller.id,
          disbursement_date:   Date.current.end_of_month)
          disbursement.disburse!

          expect(loan_application.voucher.disbursement_date).to eq Date.current.end_of_month


      end
    end
  end
end
