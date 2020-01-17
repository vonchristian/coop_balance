module BankAccounts
  class DepositsController < ApplicationController
    def new
      @bank_account = current_cooperative.bank_accounts.find(params[:bank_account_id])
      @deposit = BankAccounts::DepositLineItemProcessing.new
    end
    def create
      @bank_account = current_cooperative.bank_accounts.find(params[:bank_account_id])
      @deposit = BankAccounts::DepositLineItemProcessing.new(entry_params)
      if @deposit.valid?
        @deposit.save
        redirect_to bank_account_voucher_url(id: @deposit.find_voucher.id, bank_account_id: @bank_account.id), notice: "Entry saved successfully."
      else
        render :new
      end
    end

    private
    def entry_params
      params.require(:bank_accounts_deposit_line_item_processing).
      permit(:bank_account_id, :employee_id, :amount, :description,
      :reference_number, :account_number, :date, 
       :offline_receipt, :cash_account_id, :account_number, :payee_id)
    end
  end
end
