require 'rails_helper'

module SavingsModule
  module DateSetters
    describe Quarterly do
      let (:saving_product) { create(:saving_product, interest_recurrence: 'quarterly') }

      it "#start_date" do
        expect(described_class.new(saving_product: saving_product, date: Date.current).start_date).to eql Date.current.beginning_of_quarter
      end
      it "#end_date" do
        expect(described_class.new(saving_product: saving_product, date: Date.current).end_date).to eql Date.current.end_of_quarter
      end
    end
  end
end
