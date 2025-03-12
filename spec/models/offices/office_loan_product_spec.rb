require 'rails_helper'

module Offices
  describe OfficeLoanProduct do
    describe 'associations' do
      it { should belong_to :office }
      it { should belong_to :loan_product }

      it { should belong_to :interest_revenue_account_category }
      it { should belong_to :penalty_revenue_account_category }
      it { should belong_to :forwarding_account }
      it { should have_many :office_loan_product_aging_groups }
      it { should have_many :loan_aging_groups }
    end

    describe 'validations' do
      it 'unique loan_product scoped to office' do
        office              = create(:office)
        loan_product        = create(:loan_product)
        create(:office_loan_product, office: office, loan_product: loan_product)
        office_loan_product = build(:office_loan_product, office: office, loan_product: loan_product)
        office_loan_product.save

        expect(office_loan_product.errors[:loan_product_id]).to eql [ 'has already been taken' ]
      end
    end

    describe 'delegations' do
      it { should delegate_method(:name).to(:loan_product) }
    end
  end
end
