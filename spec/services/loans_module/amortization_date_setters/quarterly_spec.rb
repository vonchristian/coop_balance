require 'rails_helper'

module LoansModule
  module AmortizationDateSetters
    describe Quarterly do
      it "#start_date" do
        start_date = described_class.new(date: Date.current).start_date.to_date

        expect(start_date).to eq Date.current.next_quarter.to_date
      end
    end
  end
end
