module TreasuryModule
  module CashDisbursementVouchers
    class ConfirmationsController < ApplicationController
      def create
        @voucher = current_cooperative.vouchers.find(params[:cash_disbursement_voucher_id])
        Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user).process!
        redirect_to treasury_module_disbursements_url, notice: "Cash disbursement saved successfully."
      end
    end
  end
end
