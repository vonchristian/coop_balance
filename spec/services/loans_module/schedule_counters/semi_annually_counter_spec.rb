require 'rails_helper'

module LoansModule
  module ScheduleCounters
    describe SemiAnnuallyCounter do

      it 'number of months per quarter' do
        expect(LoansModule::ScheduleCounters::SemiAnnuallyCounter::NUMBER_OF_MONTHS_PER_SEMI_ANNUAL).to eql 6
      end

      it '#schedule_count' do
        loan_application_semi_annually_12 = create(:loan_application, mode_of_payment: 'semi_annually', term: 12)
        loan_application_semi_annually_48 = create(:loan_application, mode_of_payment: 'semi_annually', term: 48)

        expect(described_class.new(loan_application: loan_application_semi_annually_12).schedule_count).to eql 2
        expect(described_class.new(loan_application: loan_application_semi_annually_48).schedule_count).to eql 8
      end
    end
  end
end
