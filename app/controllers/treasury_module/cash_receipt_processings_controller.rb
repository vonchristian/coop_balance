module TreasuryModule
  class CashReceiptProcessingsController < ApplicationController
    def create
      @cash_receipt = Vouchers::DisbursementProcessing.new(cash_receipt_params)
      if @cash_receipt.valid?
        @cash_receipt.disburse!
        redirect_to treasury_module_cash_receipts_url, notice: "Cash Receipt saved successfully."
      else
        redirect_to new_treasury_module_cash_receipt_line_item_url, alert: "Error"
      end
    end
    private
    def cash_receipt_params
      params.require(:vouchers_disbursement_processing).permit(:reference_number, :date, :description, :employee_id, :payee_id)
    end
  end
end
