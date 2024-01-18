require 'rails_helper'

module SavingsModule
  module InterestRateSetters
    describe Annually do
      it 'rate_divisor' do
        saving_product = create(:saving_product, interest_recurrence: 'annually')
        expect(described_class.new(saving_product: saving_product).rate_divisor).to be 1.0
      end
    end
  end
end
