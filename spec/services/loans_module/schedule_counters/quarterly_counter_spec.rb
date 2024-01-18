require 'rails_helper'

module LoansModule
  module ScheduleCounters
    describe QuarterlyCounter do
      it 'number of months per quarter' do
        expect(LoansModule::ScheduleCounters::QuarterlyCounter::NUMBER_OF_MONTHS_PER_QUARTER).to be 3
      end

      it '#schedule_count' do
        loan_application_quarterly_12 = create(:loan_application, mode_of_payment: 'quarterly', number_of_days: 365)
        loan_application_quarterly_24 = create(:loan_application, mode_of_payment: 'quarterly', number_of_days: 730)

        expect(described_class.new(loan_application: loan_application_quarterly_12).schedule_count).to be 4
        expect(described_class.new(loan_application: loan_application_quarterly_24).schedule_count).to be 8
      end
    end
  end
end
