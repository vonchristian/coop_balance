require 'rails_helper'

module LoansModule
  describe OfficeLoanProductAgingGroup do
    describe 'associations' do
      it { is_expected.to belong_to :office_loan_product }
      it { is_expected.to belong_to :loan_aging_group }
    end

    it '.current' do
      past_due         = create(:loan_aging_group, start_num: 1, end_num: 30)
      loan_aging_group = create(:loan_aging_group, start_num: 0, end_num: 0)
      old_group = create(:office_loan_product_aging_group, created_at: Date.current.last_year, loan_aging_group: past_due)
      new_group = create(:office_loan_product_aging_group, created_at: Date.current, loan_aging_group: loan_aging_group)

      expect(described_class.current).to eq new_group
      expect(described_class.current).to_not eq old_group
    end
  end
end
