require 'rails_helper'

module Offices
  describe OfficeTimeDepositProduct, type: :model do
    describe 'associations' do
      it { should belong_to :office }
      it { should belong_to :time_deposit_product }
      it { should belong_to :liability_account_category }
      it { should belong_to :interest_expense_account_category }
      it { should belong_to :break_contract_account_category }
      it { should belong_to :forwarding_account }
    end

    describe 'validations' do
      it { should validate_presence_of :time_deposit_product_id }

      it 'unique time deposit product scope to office' do
        office = create(:office)
        time_deposit_product = create(:time_deposit_product)
        create(:office_time_deposit_product, office: office, time_deposit_product: time_deposit_product)
        office_time_deposit_product = build(:office_time_deposit_product, office: office, time_deposit_product: time_deposit_product)
        office_time_deposit_product.save

        expect(office_time_deposit_product.errors[:time_deposit_product_id]).to eq ['has already been taken']
      end
    end
  end
end
