require 'rails_helper'

module CoopConfigurationsModule
  describe StoreFrontConfig do
    describe 'associations' do
      it { is_expected.to belong_to :merchandise_inventory_account }
      it { is_expected.to belong_to :accounts_receivable_account }
      it { is_expected.to belong_to :cost_of_goods_sold_account }
      it { is_expected.to belong_to :sales_account }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :merchandise_inventory_account_id }
      it { is_expected.to validate_presence_of :cost_of_goods_sold_account_id }
      it { is_expected.to validate_presence_of :sales_account_id }
      it { is_expected.to validate_presence_of :accounts_receivable_account_id }
    end
  end
end
