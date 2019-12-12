require 'rails_helper'

module Offices
  describe OfficeShareCapitalProduct do
    describe 'associations' do
      it { is_expected.to belong_to :office }
      it { is_expected.to belong_to :share_capital_product }
      it { is_expected.to belong_to :equity_account_category }
      it { is_expected.to belong_to :forwarding_account }
    end
    describe 'validations' do
    end 
  end
end
