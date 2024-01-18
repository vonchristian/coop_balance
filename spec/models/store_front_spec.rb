require 'rails_helper'

describe StoreFront do
  describe 'associations' do
    it { should belong_to :cooperative }
    it { should belong_to :cost_of_goods_sold_account }
    it { should belong_to :merchandise_inventory_account }
    it { should belong_to :spoilage_account }
    it { should belong_to :purchase_return_account }
    it { should have_many :products }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_uniqueness_of :name }
  end
end
