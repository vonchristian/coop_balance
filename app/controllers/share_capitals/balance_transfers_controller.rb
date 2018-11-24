module ShareCapitals
  class BalanceTransfersController < ApplicationController
    def new
      @share_capital             = current_cooperative.share_capitals.find(params[:share_capital_id])
      @destination_share_capital = current_cooperative.share_capitals.find(params[:destination_share_capital_id])
      @balance_transfer          = ShareCapitals::BalanceTransferProcessing.new    end
    def create
      @share_capital             = current_cooperative.share_capitals.find(params[:share_capital_id])
      @destination_share_capital = current_cooperative.share_capitals.find(params[:share_capitals_balance_transfer_processing][:destination_id])
      @balance_transfer          = ShareCapitals::BalanceTransferProcessing.new(balance_transfer_params)
      if @balance_transfer.valid?
        @balance_transfer.process!
        redirect_to share_capital_balance_transfer_voucher_url(origin_share_capital_id: @share_capital.id, id: @balance_transfer.find_voucher.id, destination_share_capital_id: @balance_transfer.find_destination_share_capital.id), notice: " balance transfer created successfully."
      else
        render :new
      end
    end

    private
    def balance_transfer_params
      params.require(:share_capitals_balance_transfer_processing).
      permit(:origin_id, :destination_id, :reference_number, :amount, :date, :employee_id, :account_number, :description)
    end
  end
end
