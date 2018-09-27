module ShareCapitals
  class BalanceTransfersController < ApplicationController
    def new
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
      @balance_transfer = Memberships::ShareCapitals::BalanceTransferProcessing.new
    end
    def create
       @share_capital = MembershipsModule::ShareCapital.find(params[:memberships_share_capitals_balance_transfer_processing][:origin_id])
      @balance_transfer = Memberships::ShareCapitals::BalanceTransferProcessing.new(balance_transfer_params)
      if @balance_transfer.valid?
        @balance_transfer.process!
        redirect_to share_capital_url(@share_capital), notice: "Balance transfer saved successfully."
      else
        render :new
      end
    end

    private
    def balance_transfer_params
      params.require(:memberships_share_capitals_balance_transfer_processing).
      permit(:origin_id, :destination_id, :reference_number, :amount, :date, :employee_id)
    end
  end
end
