require 'rails_helper'

module CoopServicesModule
	describe ShareCapitalProductShare do
	  context 'associations' do 
	  	it { is_expected.to have_many :share_capital_product_shares }
	  	it { is_expected.to have_many :subscribers }
	  end
	end
end