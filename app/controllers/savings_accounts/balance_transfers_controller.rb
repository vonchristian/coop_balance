module SavingsAccounts
  class BalanceTransfersController < ApplicationController
    def new
      @origin_saving      = current_cooperative.savings.find(params[:savings_account_id])
      @destination_saving = current_cooperative.savings.find(params[:destination_saving_id])
      @balance_transfer   = SavingsAccounts::BalanceTransferProcessing.new
    end
    def create
      @origin_saving    = current_cooperative.savings.find(params[:savings_account_id])
      @balance_transfer = SavingsAccounts::BalanceTransferProcessing.new(balance_transfer_params)
      if @balance_transfer.valid?
        @balance_transfer.process!
        redirect_to savings_account_balance_transfer_voucher_url(id: @origin_saving.id, voucher_id: @balance_transfer.find_voucher.id, destination_saving_id: @balance_transfer.find_destination_saving.id), notice: "saved successfully."
      else
        render :new
      end
    end

    private
    def balance_transfer_params
      params.require(:savings_accounts_balance_transfer_processing).
      permit(:origin_id, :destination_id, :employee_id, :amount,
      :reference_number, :account_number, :date)
    end
  end
end
