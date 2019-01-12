require 'rails_helper'

module LoansModule
  module ScheduleCounters
    describe WeeklyCounter do

      it 'number of weeks per month' do
        expect(LoansModule::ScheduleCounters::WeeklyCounter::NUMBER_OF_WEEKS_PER_MONTH).to eql 4
      end

      it '#schedule_count' do
        loan_application_weekly_2 = create(:loan_application, mode_of_payment: 'weekly', term: 2)
        loan_application_weekly_4 = create(:loan_application, mode_of_payment: 'weekly', term: 4)

        expect(described_class.new(loan_application: loan_application_weekly_2).schedule_count).to eql 8
        expect(described_class.new(loan_application: loan_application_weekly_4).schedule_count).to eql 16
      end
    end
  end
end
