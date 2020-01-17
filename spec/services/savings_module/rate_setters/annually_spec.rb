require 'rails_helper'

module SavingsModule
  module RateSetters 
    describe Annually do 
      it '#applicable_rate' do 
        saving_product = create(:saving_product)
        saving_product_interest_config = create(:saving_product_interest_config, interest_posting: 'annually', annual_rate: 0.03)

        rate = described_class.new(saving_product_interest_config: saving_product_interest_config).applicable_rate 

        expect(rate).to eql 0.03 
      end 
    end 
  end 
end 
