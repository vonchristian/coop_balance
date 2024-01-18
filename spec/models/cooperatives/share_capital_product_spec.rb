require 'rails_helper'

module Cooperatives
  describe ShareCapitalProduct do
    context 'associations' do
      it { should belong_to :cooperative }
      it { should belong_to :office }
      it { should have_many :subscribers }
    end

    describe 'validations' do
      it { should validate_presence_of :name }
      it { should validate_uniqueness_of(:name).scoped_to(:cooperative_id) }
      it { should validate_presence_of :cost_per_share }
      it { should validate_numericality_of :cost_per_share }
    end

    it '#minimum_balance' do
      share_capital_product = build(:share_capital_product, cost_per_share: 100, minimum_number_of_paid_share: 10)

      expect(share_capital_product.minimum_balance).to be 1_000
    end
  end
end
