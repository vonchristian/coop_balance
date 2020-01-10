module SavingsAccounts
  class MultipleLineItemsController < ApplicationController 
    def new 
      @savings_account = current_office.savings.find(params[:savings_account_id])
      @line_item       = SavingsAccounts::MultiplePayment.new 
    end 

    def create 
      @savings_account = current_office.savings.find(params[:savings_account_id])
      @line_item       = SavingsAccounts::MultiplePayment.new(payment_params)
      if @line_item.valid?
        @line_item.process!
        redirect_to new_savings_account_multiple_transaction_url, notice: 'added successfully.'
      else 
        render :new 
      end 
    end 

    def destroy 
      @savings_account = current_office.savings.find(params[:savings_account_id])
      @amount        = current_cart.voucher_amounts.find(params[:id])
      @amount.destroy 
      redirect_to new_savings_account_multiple_transaction_url, notice: 'Removed successfully'
    end 


    private 
    def payment_params
      params.require(:savings_accounts_multiple_payment).
      permit(:savings_account_id, :amount, :employee_id, :cart_id)
    end 
  end 
end 