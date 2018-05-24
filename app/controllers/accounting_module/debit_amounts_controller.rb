module AccountingModule
  class DebitAmountsController < ApplicationController
    def edit
      @amount = AccountingModule::DebitAmount.find(params[:id])
      @entry = @amount.entry
    end
    def update
      @amount = AccountingModule::DebitAmount.find(params[:id])
      @amount.update(amount_params)
      if @amount.save
        redirect_to accounting_module_entry_url(@amount.entry), notice: "Amount updated successfully"
      else
        render :edit
      end
    end

    private
    def amount_params
      params.require(:accounting_module_debit_amount).permit(:amount, :account_id)
    end
  end
end

