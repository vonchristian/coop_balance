module AccountingModule
  class CreditAmountsController < ApplicationController
    def edit
      @amount = AccountingModule::CreditAmount.find(params[:id])
      @entry = @amount.entry
    end
    def update
      @amount = AccountingModule::CreditAmount.find(params[:id])
      @amount.update(amount_params)
      if @amount.save
        redirect_to accounting_module_entry_url(@amount.entry), notice: "Amount updated successfully"
      else
        render :edit
      end
    end

    private
    def amount_params
      params.require(:accounting_module_credit_amount).permit(:amount, :account_id)
    end
  end
end

