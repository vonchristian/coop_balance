require 'rails_helper'

module Offices
  describe OfficeTimeDepositProduct, type: :model do
    describe 'associations' do
      it { is_expected.to belong_to :office }
      it { is_expected.to belong_to :time_deposit_product }
      it { is_expected.to belong_to :liability_account_category }
      it { is_expected.to belong_to :interest_expense_account_category }
      it { is_expected.to belong_to :break_contract_account_category}
    end 
  end
end
