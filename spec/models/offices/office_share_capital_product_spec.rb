require 'rails_helper'

module Offices
  describe OfficeShareCapitalProduct do
    describe 'associations' do
      it { should belong_to :office }
      it { should belong_to :share_capital_product }
      it { should belong_to :equity_account_category }
      it { should belong_to :forwarding_account }
    end

    describe 'validations' do
    end
  end
end
