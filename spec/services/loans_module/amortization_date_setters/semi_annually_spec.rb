require 'rails_helper'

module LoansModule
  module AmortizationDateSetters
    describe SemiAnnually do
      it "#start_date" do
        start_date = described_class.new(date: Date.current).start_date.to_date

        expect(start_date).to eq((Date.current + 6.months).to_date)
      end
    end
  end
end
