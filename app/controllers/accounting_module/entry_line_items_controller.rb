module AccountingModule
  class EntryLineItemsController < ApplicationController
    def new
      @line_item = AccountingModule::Entries::VoucherAmountProcessing.new
      @voucher = Vouchers::VoucherProcessing.new
      if params[:commercial_document_type] && params[:commercial_document_id]
        @commercial_document = params[:commercial_document_type].constantize.find(params[:commercial_document_id])
      end
    end

    def create
      @line_item = AccountingModule::Entries::VoucherAmountProcessing.new(amount_params)
      if @line_item.valid?
        @line_item.process!
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
    def amount_params
      params.require(:accounting_module_entries_voucher_amount_processing).
      permit(:amount, :account_id, :description, :amount_type, :employee_id)
    end
  end
end
