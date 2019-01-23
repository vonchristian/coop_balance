require 'rails_helper'

module SavingsModule
  module InterestRateDivisors
    describe Quarterly do
      it "rate_divisor" do
        saving_product = create(:saving_product, interest_recurrence: 'quarterly')
        expect(described_class.new(saving_product: saving_product).rate_divisor).to eql 4.0
      end
    end
  end
end
