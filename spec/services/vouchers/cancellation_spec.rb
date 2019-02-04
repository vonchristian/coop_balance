require 'rails_helper'

module Vouchers
  describe Cancellation do
    it 'cancels undisbursed_voucher' do
      voucher = create(:voucher, cancelled_at: nil)

      described_class.new(voucher: voucher).cancel!

      expect(voucher.cancelled?).to be true
    end
  end
end
