require 'rails_helper'

module LoansModule
  module ScheduleCounters
    describe DailyCounter do
      it '#schedule_count' do
        loan_application_daily_1 = create(:loan_application, mode_of_payment: 'daily', term: 1)
        loan_application_daily_2 = create(:loan_application, mode_of_payment: 'daily', term: 2)

        expect(described_class.new(loan_application: loan_application_daily_1).schedule_count).to eql 30
        expect(described_class.new(loan_application: loan_application_daily_2).schedule_count).to eql 60
      end
    end
  end
end
