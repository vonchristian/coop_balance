module ShareCapitals
  class BalanceTransferProcessingsController < ApplicationController
    def new
      @origin_share_capital      = current_office.share_capitals.find(params[:share_capital_id])
      @destination_share_capital = current_office.share_capitals.find(params[:destination_share_capital_id])

      @balance_transfer          = ShareCapitals::BalanceTransferProcessing.new
    end
    def create
      @origin_share_capital      = current_office.share_capitals.find(params[:share_capital_id])
      @destination_share_capital = current_office.share_capitals.find(params[:share_capitals_balance_transfer_processing][:destination_share_capital_id])
     
      @balance_transfer          = ShareCapitals::BalanceTransferProcessing.new(balance_transfer_params)
      if @balance_transfer.valid?
        @balance_transfer.process!
        redirect_to new_share_capital_balance_transfer_url(@origin_share_capital), notice: "Amount created successfully."
      else
        render :new
      end
    end
    
    def destroy
      @origin_share_capital = current_office.share_capitals.find(params[:share_capital_id])
      @amount               = current_cart.voucher_amounts.find(params[:id])
      @amount.destroy
      redirect_to new_share_capital_balance_transfer_url(share_capital_id: @share_capital.id), alert: 'Removed successfully'
    end

    private
    def balance_transfer_params
      params.require(:share_capitals_balance_transfer_processing).
      permit(:origin_share_capital_id, :destination_share_capital_id, :amount, :cart_id, :employee_id)
    end
  end
end
