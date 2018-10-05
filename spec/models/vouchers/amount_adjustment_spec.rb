require 'rails_helper'

module Vouchers
  describe AmountAdjustment do
    describe 'associations' do
      it { is_expected.to belong_to :loan_application }
      it { is_expected.to have_many :voucher_amounts }
    end
  end
end
