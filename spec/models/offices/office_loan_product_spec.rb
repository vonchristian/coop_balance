require 'rails_helper'

module Offices
  describe OfficeLoanProduct do
    describe 'associations' do
      it { is_expected.to belong_to :office }
      it { is_expected.to belong_to :loan_product }
      it { is_expected.to belong_to :receivable_account_category }
      it { is_expected.to belong_to :interest_revenue_account_category }
      it { is_expected.to belong_to :penalty_revenue_account_category }
      it { is_expected.to belong_to :forwarding_account }
    end
  end 
end