module TreasuryModule
  class CashReceiptLineItemsController < ApplicationController
    def new
      @cash_receipt_line_item = TreasuryModule::CashReceiptLineItemProcessing.new
      @cash_receipt = Vouchers::DisbursementProcessing.new
    end
    def create
      @cash_receipt_line_item = TreasuryModule::CashReceiptLineItemProcessing.new(disbursement_params)
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
      params.require(:treasury_module_cash_receipt_line_item_processing).
      permit(:amount, :account_id, :description, :employee_id)
    end
  end
end

