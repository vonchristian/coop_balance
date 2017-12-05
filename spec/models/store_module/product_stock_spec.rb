require 'rails_helper'

  module StoreModule
  describe ProductStock do
    context "associations" do
    	it { is_expected.to belong_to :product }
    	it { is_expected.to belong_to :supplier }
    end
    context 'validations' do
      it { is_expected.to validate_numericality_of :unit_cost }
      it { is_expected.to validate_numericality_of :total_cost }
      it { is_expected.to validate_numericality_of :quantity }
      it { is_expected.to validate_numericality_of :retail_price }
      it { is_expected.to validate_numericality_of :wholesale_price }
      it { is_expected.to validate_presence_of :supplier_id }
    end

    context 'delegations' do
    	it { is_expected.to delegate_method(:name).to(:product) }
    end
  end
end
