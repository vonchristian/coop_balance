module TreasuryModule
  class CashDisbursementVoucherProcessingsController < ApplicationController
    def create
      @cash_account = current_cooperative.accounts.find(params[:vouchers_voucher_processing][:cash_account_id])
      @cash_disbursement = Vouchers::VoucherProcessing.new(cash_receipt_params)
      if @cash_disbursement.valid?
        @cash_disbursement.process!
        redirect_to treasury_module_cash_account_cash_disbursement_voucher_url(cash_account_id: @cash_account.id, id: @cash_disbursement.find_voucher.id), notice: "Disbursement saved successfully."
      else
        redirect_to new_treasury_module_cash_account_cash_disbursement_line_item_url(@cash_account), notice: "Error"
      end
    end
    private
    def cash_receipt_params
      params.require(:vouchers_voucher_processing).permit(:reference_number, :date, :description, :employee_id, :payee_id, :cooperative_service_id, :account_number)
    end
  end
end
