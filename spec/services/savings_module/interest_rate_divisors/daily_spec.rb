require 'rails_helper'

module SavingsModule
  module InterestRateDivisors
    describe Daily do
      it "rate_divisor" do
        saving_product = create(:saving_product, interest_recurrence: 'daily')
        expect(saving_product.applicable_divisor).to eql described_class
        expect(described_class.new(saving_product: saving_product).rate_divisor).to eql 364.0
      end
    end
  end
end
