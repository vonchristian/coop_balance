require 'rails_helper'

module SavingsModule
  module InterestRateSetters
    describe SemiAnnually do
      it 'rate_divisor' do
        saving_product = create(:saving_product, interest_recurrence: 'semi_annually')
        expect(described_class.new(saving_product: saving_product).rate_divisor).to be 2.0
      end
    end
  end
end
