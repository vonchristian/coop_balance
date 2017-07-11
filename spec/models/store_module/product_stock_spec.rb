require 'rails_helper'

  module StoreModule
  describe ProductStock do
    context "associations" do 
    	it { is_expected.to belong_to :product }
    	it { is_expected.to belong_to :supplier }
    end
    context 'delegations' do 
    	it { is_expected.to delegate_method(:name).to(:product) }
    end
  end
end
