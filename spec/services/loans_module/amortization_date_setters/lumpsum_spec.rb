require 'rails_helper'

module LoansModule
  module AmortizationDateSetters
    describe Lumpsum do
      it '#start_date' do
        expect(described_class.new(number_of_days: 730, date: Date.current).start_date.to_date).to eq (Date.current + 730.days).to_date

        expect(described_class.new(number_of_days: 365, date: Date.current).start_date.to_date).to eq (Date.current + 365.days).to_date
      end
    end
  end
end
