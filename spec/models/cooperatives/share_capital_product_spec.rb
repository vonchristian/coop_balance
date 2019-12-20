require 'rails_helper'

module Cooperatives
  describe ShareCapitalProduct do
	  context 'associations' do
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :office }
	  	it { is_expected.to have_many :subscribers }
    end
    
    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:cooperative_id) }
      it { is_expected.to validate_presence_of :cost_per_share }
      it { is_expected.to validate_numericality_of :cost_per_share }
    end

    it "#minimum_balance" do
      share_capital_product = build(:share_capital_product, cost_per_share: 100, minimum_number_of_paid_share: 10)

      expect(share_capital_product.minimum_balance).to eql 1_000
    end
	end
end
