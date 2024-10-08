require 'rails_helper'

module LoansModule
  module ScheduleCounters
    describe LumpsumCounter do
      it '#schedule_count' do
        loan_application_lumpsum_12 = create(:loan_application, mode_of_payment: 'lumpsum', number_of_days: 30)
        loan_application_lumpsum_24 = create(:loan_application, mode_of_payment: 'lumpsum', number_of_days: 365)

        expect(described_class.new(loan_application: loan_application_lumpsum_12).schedule_count).to be 1
        expect(described_class.new(loan_application: loan_application_lumpsum_24).schedule_count).to be 1
      end
    end
  end
end
