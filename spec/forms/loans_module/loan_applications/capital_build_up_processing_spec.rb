require 'rails_helper'

module LoansModule
  module LoanApplications
    describe CapitalBuildUpProcessing do
      it '#process!' do
        member = create(:member)
        loan_application = create(:loan_application, borrower: member)
        share_capital    = create(:share_capital, subscriber: member)
        employee         = create(:loan_officer)
        described_class.new(
          amount: 100,
          loan_application_id: loan_application.id,
          share_capital_id: share_capital.id,
          employee_id: employee.id
        ).process!

        expect(loan_application.voucher_amounts.pluck(:account_id)).to include(share_capital.equity_account_id)
      end
    end
  end
end