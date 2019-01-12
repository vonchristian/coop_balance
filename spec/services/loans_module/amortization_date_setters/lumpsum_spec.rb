require 'rails_helper'

module LoansModule
  module AmortizationDateSetters
    describe Lumpsum do
      it "#start_date" do
        expect(described_class.new(term: 48, date: Date.current).start_date.to_date).to eq (Date.current + 48.months).to_date

        expect(described_class.new(term: 12, date: Date.current).start_date.to_date).to eq (Date.current + 12.months).to_date
      end
    end
  end
end
