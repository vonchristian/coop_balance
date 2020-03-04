require 'rails_helper'

describe StoreFront do
  describe 'associations' do
    it { is_expected.to belong_to :cooperative }
    it { is_expected.to belong_to :cost_of_goods_sold_account }
    it { is_expected.to belong_to :merchandise_inventory_account }
    it { is_expected.to belong_to :spoilage_account }
    it { is_expected.to belong_to :purchase_return_account }
    it { is_expected.to have_many :products }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :address }
    it { is_expected.to validate_uniqueness_of :name }
  end
end
