module TreasuryModule
  module CashReceiptVouchers
    class ConfirmationsController < ApplicationController
      def create
        @voucher = current_cooperative.vouchers.find(params[:cash_receipt_voucher_id])
        Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user).process!
        redirect_to treasury_module_cash_receipts_url, notice: "Cash receipts saved successfully."
      end
    end
  end
end
