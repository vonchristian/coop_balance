module AccountingModule
  class CreditAmountsController < ApplicationController
    def edit
      @amount = AccountingModule::CreditAmount.find(params[:id])
      @entry = @amount.entry
      @accounts = if params[:text_search].present?
                    current_office.accounts.text_search(params[:text_search])
                  else
                    @entry.accounts
                  end
      @account = params[:account_id] ? current_office.accounts.find_by(id: params[:account_id]) : @amount.account
    end

    def update
      @amount = AccountingModule::CreditAmount.find(params[:id])
      @amount.update(amount_params)
      if @amount.save
        redirect_to accounting_module_entry_url(@amount.entry), notice: 'Amount updated successfully'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def amount_params
      params.require(:accounting_module_credit_amount).permit(:amount, :account_id)
    end
  end
end
