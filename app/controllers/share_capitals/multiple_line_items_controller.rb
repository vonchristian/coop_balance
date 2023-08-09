module ShareCapitals 
  class MultipleLineItemsController < ApplicationController 
    def new 
      @share_capital = current_office.share_capitals.find(params[:share_capital_id])
      @line_item     = ShareCapitals::MultiplePayment.new 
    end 

    def create 
      @share_capital = current_office.share_capitals.find(params[:share_capital_id])
      @line_item     = ShareCapitals::MultiplePayment.new(payment_params)
      if @line_item.valid?
        @line_item.process!
        redirect_to new_share_capital_multiple_transaction_url, notice: 'added successfully.'
      else 
        render :new, status: :unprocessable_entity
      end 
    end 

    def destroy 
      @share_capital = current_office.share_capitals.find(params[:share_capital_id])
      @amount        = current_cart.voucher_amounts.find(params[:id])
      @amount.destroy 
      redirect_to new_share_capital_multiple_transaction_url, notice: 'Removed successfully'
    end 


    private 
    def payment_params
      params.require(:share_capitals_multiple_payment).
      permit(:share_capital_id, :amount, :employee_id, :cart_id)
    end 
  end 
end 