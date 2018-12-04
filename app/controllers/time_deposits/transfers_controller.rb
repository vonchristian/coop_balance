module TimeDeposits
  class TransfersController < ApplicationController
    def new
      @time_deposit    = current_cooperative.time_deposits.find(params[:time_deposit_id])
      @transfer        = TimeDeposits::TransferProcessing.new
      @saving_products = current_cooperative.saving_products
    end
    def create
      @time_deposit    = current_cooperative.time_deposits.find(params[:time_deposit_id])
      @transfer        = TimeDeposits::TransferProcessing.new(transfer_params)
      if @transfer.valid?
        @transfer.process!
        redirect_to time_deposit_transfer_voucher_url(time_deposit_id: @time_deposit.id, id: @transfer.find_voucher.id, savings_account_application: @transfer.find_savings_account_application.id)
      else
        render :new
      end
    end

    private
    def transfer_params
      params.require(:time_deposits_transfer_processing).
      permit(:time_deposit_id, :saving_product_id, :account_number, :date, :employee_id, :cooperative_id, :description)
    end
  end
end
