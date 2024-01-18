require 'rails_helper'

module LoansModule
  module ScheduleCounters
    describe WeeklyCounter do
      it 'number of weeks per month' do
        expect(LoansModule::ScheduleCounters::WeeklyCounter::NUMBER_OF_DAYS_PER_WEEK).to be 7
      end

      it '#schedule_count' do
        loan_application_weekly_2 = create(:loan_application, mode_of_payment: 'weekly', number_of_days: 14)
        loan_application_weekly_4 = create(:loan_application, mode_of_payment: 'weekly', number_of_days: 30)

        expect(described_class.new(loan_application: loan_application_weekly_2).schedule_count).to be 2
        expect(described_class.new(loan_application: loan_application_weekly_4).schedule_count).to be 4
      end
    end
  end
end
