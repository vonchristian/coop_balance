module SavingsAccounts
  class BalanceTransferProcessingsController < ApplicationController
    def new 
      @savings_account  = current_office.savings.find(params[:savings_account_id])
      @destination_savings_account  = current_office.savings.find(params[:destination_savings_account_id])

      @balance_transfer = SavingsAccounts::BalanceTransfer.new
    end
    
    def create
      @savings_account  = current_office.savings.find(params[:savings_account_id])
      @destination_savings_account  = current_office.savings.find(params[:savings_accounts_balance_transfer][:destination_savings_account_id])
      @balance_transfer = SavingsAccounts::BalanceTransfer.new(balance_transfer_params)
      if @balance_transfer.valid?
        @balance_transfer.process!
        redirect_to new_savings_account_balance_transfer_url(origin_saving_id: @savings_account.id), notice: 'Added successfully'
      else 
        render :new, status: :unprocessable_entity
      end 
    end

    def destroy 
      @savings_account = current_office.savings.find(params[:savings_account_id])
      @amount = current_cart.voucher_amounts.find(params[:id])
      @amount.destroy 
      redirect_to new_savings_account_balance_transfer_url(@savings_account), notice: 'removed successfully'
    end 

    private 
    def balance_transfer_params
      params.require(:savings_accounts_balance_transfer).
      permit(:origin_saving_id, :cart_id, :amount, :destination_savings_account_id, :employee_id)
    end 
  end 
end 
