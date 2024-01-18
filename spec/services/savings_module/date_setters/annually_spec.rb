require 'rails_helper'

module SavingsModule
  module DateSetters
    describe Annually do
      let(:saving_product_interest_config) { create(:saving_product_interest_config, interest_posting: 'annually') }

      it '#beginning_date' do
        expect(described_class.new(saving_product_interest_config: saving_product_interest_config, date: Date.current).beginning_date).to eql Date.current.beginning_of_year
      end

      it '#ending_date' do
        expect(described_class.new(saving_product_interest_config: saving_product_interest_config, date: Date.current).ending_date).to eql Date.current.end_of_year
      end
    end
  end
end
