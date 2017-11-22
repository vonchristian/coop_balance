require 'rails_helper'

module LoansModule
  describe PrincipalAmortizationSchedule do
    describe ".starting_date(loan)" do
      it "for undisbursed loan" do
        loan = create(:loan, application_date: Date.today)

        expect(LoansModule::PrincipalAmortizationSchedule.starting_date(loan).to_date).to eql(Date.today)
      end
      it "for disbursed loan" do
        loan = create(:loan, application_date: Date.today)
        disbursement = create(:entry_with_credit_and_debit, commercial_document: loan, entry_type: 'loan_disbursement', entry_date: Date.today.next_week)

        expect(LoansModule::PrincipalAmortizationSchedule.starting_date(loan).to_date).to eql(Date.today.next_week)
      end
    end
  end
end
