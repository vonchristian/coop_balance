module AccountingModule
  class DebitAmountsController < ApplicationController
    def edit
      @amount = AccountingModule::DebitAmount.find(params[:id])
      @entry = @amount.entry
      if params[:text_search].present?
        @accounts = current_office.accounts.text_search(params[:text_search])
      else 
        @accounts = @entry.accounts
      end
      @account = params[:account_id] ? current_office.accounts.find_by(id: params[:account_id]) : @amount.account
      
    end

    def update
      @amount = AccountingModule::DebitAmount.find(params[:id])
      @amount.update(amount_params)
      if @amount.save
        redirect_to accounting_module_entry_url(@amount.entry), notice: "Amount updated successfully"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
    def amount_params
      params.require(:accounting_module_debit_amount).permit(:amount, :account_id)
    end
  end
end
