require 'rails_helper'

module LoansModule
  module ScheduleCounters
    describe LumpsumCounter do
      it '#schedule_count' do
        loan_application_lumpsum_12 = create(:loan_application, mode_of_payment: 'lumpsum', term: 12)
        loan_application_lumpsum_24 = create(:loan_application, mode_of_payment: 'lumpsum', term: 24)

        expect(described_class.new(loan_application: loan_application_lumpsum_12).schedule_count).to eql 1
        expect(described_class.new(loan_application: loan_application_lumpsum_24).schedule_count).to eql 1
      end
    end
  end
end
