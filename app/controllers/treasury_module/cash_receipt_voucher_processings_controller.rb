module TreasuryModule
  class CashReceiptVoucherProcessingsController < ApplicationController
    def create
      @cash_account = params[:vouchers_voucher_processing][:cash_account_id]
      @cash_receipt = Vouchers::VoucherProcessing.new(cash_receipt_params)
      if @cash_receipt.valid?
        @cash_receipt.process!
        redirect_to treasury_module_cash_receipt_voucher_url(id: @cash_receipt.find_voucher.id), notice: "Voucher created successfully."
      else
        redirect_to new_treasury_module_cash_account_cash_receipt_line_item_url(@cash_account), alert: "Error"
      end
    end

    private

    def cash_receipt_params
      params.require(:vouchers_voucher_processing).permit(:cash_account_id, :reference_number, :date, :description, :employee_id, :payee_id, :cooperative_service_id, :account_number, :cart_id)
    end
  end
end
