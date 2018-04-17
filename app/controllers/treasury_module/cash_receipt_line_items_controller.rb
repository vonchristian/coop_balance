module TreasuryModule
  class CashReceiptLineItemsController < ApplicationController
    def new
      @cash_receipt_line_item = Vouchers::VoucherAmountProcessing.new
      @cash_receipt = Vouchers::DisbursementProcessing.new
    end
    def create
      @cash_receipt_line_item = Vouchers::VoucherAmountProcessing.new(disbursement_params)
      if @cash_receipt_line_item.valid?
        @cash_receipt_line_item.save
        redirect_to new_treasury_module_cash_receipt_line_item_url, notice: "Added successfully"
      else
        render :new
      end
    end
    def destroy
      @amount = Vouchers::VoucherAmount.find(params[:id])
      @amount.destroy
      redirect_to new_treasury_module_cash_receipt_line_item_url, notice: "removed successfully"
    end

    private
    def disbursement_params
      params.require(:vouchers_voucher_amount_processing).
      permit(:amount, :account_id, :description, :amount_type, :employee_id)
    end
  end
end

