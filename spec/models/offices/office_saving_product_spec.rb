require 'rails_helper'

module Offices
  describe OfficeSavingProduct do
    describe 'associations' do
      it { should belong_to :saving_product }
      it { should belong_to :office }
      it { should belong_to :liability_account_category }
      it { should belong_to :interest_expense_account_category }
      it { should belong_to :closing_account_category }
      it { should belong_to :forwarding_account }
    end

    describe 'validations' do
      it { should validate_presence_of :saving_product_id }

      it 'unique saving product scope to office' do
        office                = create(:office)
        saving_product        = create(:saving_product)
        create(:office_saving_product, office: office, saving_product: saving_product)
        office_saving_product = build(:office_saving_product, office: office, saving_product: saving_product)
        office_saving_product.save

        expect(office_saving_product.errors[:saving_product_id]).to eq [ 'has already been taken' ]
      end
    end

    describe 'delegations' do
      it { should delegate_method(:name).to(:saving_product).with_prefix }
    end
  end
end
