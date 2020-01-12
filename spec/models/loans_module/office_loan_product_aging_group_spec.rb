require 'rails_helper'

module LoansModule
  describe OfficeLoanProductAgingGroup do
    describe 'associations' do 
      it { is_expected.to belong_to :office_loan_product }
      it { is_expected.to belong_to :loan_aging_group }
      it { is_expected.to belong_to :level_one_account_category }
    end 

    it '.current' do 
      old_group = create(:office_loan_product_aging_group, created_at: Date.current.last_year)
      new_group = create(:office_loan_product_aging_group, created_at: Date.current)

      expect(described_class.current).to eq new_group
      expect(described_class.current).to_not eq old_group
    end 
  end 
end
