require 'rails_helper'

module Offices
  describe OfficeSavingProduct do
    describe 'associations' do
      it { is_expected.to belong_to :saving_product }
      it { is_expected.to belong_to :office }
      it { is_expected.to belong_to :liability_account_category }
      it { is_expected.to belong_to :interest_expense_account_category }
      it { is_expected.to belong_to :closing_account_category }
      it { is_expected.to belong_to :forwarding_account }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :saving_product_id }

      it 'unique saving product scope to office' do
        office                = create(:office)
        saving_product        = create(:saving_product)
        create(:office_saving_product, office: office, saving_product: saving_product)
        office_saving_product = build(:office_saving_product, office: office, saving_product: saving_product)
        office_saving_product.save

        expect(office_saving_product.errors[:saving_product_id]).to eq ['has already been taken']
      end
    end
  end
end
