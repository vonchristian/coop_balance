module TreasuryModule
  module CashDisbursementVouchers
    class ConfirmationsController < ApplicationController
      def create
        @voucher = current_cooperative.vouchers.find(params[:cash_disbursement_voucher_id])
        Vouchers::DisbursementProcessing.new(voucher_id: @voucher.id, employee_id: current_user.id).process!
        redirect_to treasury_module_disbursements_url, notice: "Cash disbursement saved successfully."
      end
    end
  end
end
