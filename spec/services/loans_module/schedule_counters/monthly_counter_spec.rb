require 'rails_helper'

module LoansModule
  module ScheduleCounters
    describe MonthlyCounter do
      it '#schedule_count' do
        loan_application_2 = create(:loan_application, mode_of_payment: 'monthly', term: 2)
        loan_application_12 = create(:loan_application, mode_of_payment: 'monthly', term: 12)


        expect(described_class.new(loan_application: loan_application_2).schedule_count).to eql 2
        expect(described_class.new(loan_application: loan_application_12).schedule_count).to eql 12
      end
    end
  end
end