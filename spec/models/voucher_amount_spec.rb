require 'rails_helper'

module Vouchers
  describe VoucherAmount do
    describe 'associations' do
      it { is_expected.to belong_to :account }
      it { is_expected.to belong_to :voucher }
      it { is_expected.to belong_to :commercial_document }
    end
  end
end
