require 'rails_helper'

module SavingsModule
  module InterestRateSetters
    describe Quarterly do
      it 'rate_divisor' do
        saving_product = create(:saving_product, interest_recurrence: 'quarterly')
        expect(described_class.new(saving_product: saving_product).rate_divisor).to be 4.0
      end
    end
  end
end
