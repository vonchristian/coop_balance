module BankAccounts
  class WithdrawalsController < ApplicationController
    def new
      @bank_account = current_cooperative.bank_accounts.find(params[:bank_account_id])
      @withdrawal = BankAccounts::WithdrawLineItemProcessing.new
    end
    def create
      @bank_account = current_cooperative.bank_accounts.find(params[:bank_account_id])
      @withdrawal = BankAccounts::WithdrawLineItemProcessing.new(withdrawal_params)
      if @withdrawal.valid?
        @withdrawal.process!
        redirect_to bank_account_voucher_url(id: @withdrawal.find_voucher.id, bank_account_id: @bank_account.id), notice: "Entry saved successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private
    def withdrawal_params
      params.require(:bank_accounts_withdraw_line_item_processing).
      permit(:bank_account_id, :employee_id, :amount, :description,
      :reference_number, :account_number, :date, 
       :offline_receipt, :cash_account_id, :account_number, :payee_id)
    end
  end
end
