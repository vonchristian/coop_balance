module ShareCapitals
  class BalanceTransferDestinationAccountsController < ApplicationController
    def new
      @origin_share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
      @destination_share_capital = ShareCapitals::BalanceTransferDestinationAccountProcessing.new
      if params[:search].present?
        @share_capitals = MembershipsModule::ShareCapital.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
      else
        @share_capitals = current_cooperative.share_capitals.paginate(page: params[:page], per_page: 25)
      end
    end
    def create
      @origin_share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
      @destination_share_capital = ShareCapitals::BalanceTransferDestinationAccountProcessing.new(destination_params)
      redirect_to new_share_capital_balance_transfer_url(destination_share_capital_id: @destination_share_capital.find_destination_share_capital.id, origin_share_capital_id: @origin_share_capital.id)
    end

    private
    def destination_params
      params.require(:share_capitals_balance_transfer_destination_account_processing).
      permit(:destination_share_capital_id)
    end
  end
end
