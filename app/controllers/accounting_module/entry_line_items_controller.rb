module AccountingModule
  class EntryLineItemsController < ApplicationController
    def new
      @line_item = Vouchers::VoucherAmountProcessing.new
      @voucher = Vouchers::VoucherProcessing.new
    end
    def create
      @line_item = Vouchers::VoucherAmountProcessing.new(disbursement_params)
      if @line_item.valid?
        @line_item.save
        redirect_to new_accounting_module_entry_line_item_url, notice: "Added successfully"
      else
        render :new
      end
    end
    def destroy
      @amount = current_cooperative.voucher_amounts.find(params[:id])
      @amount.destroy
      redirect_to new_accounting_module_entry_line_item_url, notice: "removed successfully"
    end

    private
    def disbursement_params
      params.require(:vouchers_voucher_amount_processing).
      permit(:amount, :account_id, :description, :amount_type, :employee_id)
    end
  end
end
