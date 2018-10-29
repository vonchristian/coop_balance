module SavingsAccounts
  class BalanceTransferDestinationAccountsController < ApplicationController
    def new
      @origin_saving = MembershipsModule::Saving.find(params[:origin_saving_id])
      @destination_saving = SavingsAccounts::BalanceTransferDestinationAccountProcessing.new
      if params[:search].present?
        @savings_accounts = MembershipsModule::Saving.text_search(params[:search]).paginate(page: params[:page], per_page: 25)
      else
        @savings_accounts = current_cooperative.savings.paginate(page: params[:page], per_page: 25)
      end
    end
    def create
      @origin_saving = MembershipsModule::Saving.find(params[:savings_account_id])
      @destination_saving = SavingsAccounts::BalanceTransferDestinationAccountProcessing.new(destination_params)
      redirect_to new_savings_account_balance_transfer_url(destination_saving_id: @destination_saving.find_destination_saving.id, origin_saving_id: @origin_saving.id)
    end

    def destination_params
      params.require(:savings_accounts_balance_transfer_destination_account_processing).
      permit(:destination_saving_id)
    end
  end
end