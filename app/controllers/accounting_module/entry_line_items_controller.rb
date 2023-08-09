module AccountingModule
  class EntryLineItemsController < ApplicationController

    def new
      @line_item = AccountingModule::Entries::VoucherAmountProcessing.new
      @voucher   = Vouchers::VoucherProcessing.new
      @account   = current_office.accounts.find_by(id: params[:account_id])
      if params[:text_search].present?
        @accounts = current_office.accounts.text_search(params[:text_search])
      else
        @pagy, @accounts = pagy(current_office.accounts)
      end
    end

    def create
      @voucher   = Vouchers::VoucherProcessing.new

      if params[:text_search].present?
        @accounts = current_office.accounts.text_search(params[:text_search])
      else
        @pagy, @accounts = pagy(current_office.accounts)
      end
      @line_item = AccountingModule::Entries::VoucherAmountProcessing.new(amount_params)
      if @line_item.valid?
        @line_item.process!
        redirect_to new_accounting_module_entry_line_item_url, notice: "Amount added successfully"
      else
        render :new, status: :unprocessable_entity
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
      permit(:amount, :account_id, :description, :amount_type, :employee_id, :cart_id)
    end
  end
end
