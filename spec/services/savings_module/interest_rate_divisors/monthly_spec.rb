require 'rails_helper'

module SavingsModule
  module InterestRateDivisors
    describe Monthly do
      it "rate_divisor" do
        saving_product = create(:saving_product, interest_recurrence: 'monthly')
        expect(described_class.new(saving_product: saving_product).rate_divisor).to eql 12.0
      end
    end
  end
end
