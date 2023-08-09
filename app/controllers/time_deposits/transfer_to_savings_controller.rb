module TimeDeposits
  class TransferToSavingsController < ApplicationController
    def new
      @time_deposit = current_office.time_deposits.find(params[:time_deposit_id])
      @transfer     = TimeDeposits::TransferProcessing.new
      @savings      = @time_deposit.depositor.savings
      if params[:saving_id].present?
        @saving = @time_deposit.depositor.savings.find(params[:saving_id])
      end 
    end
    def create
      @time_deposit    = current_office.time_deposits.find(params[:time_deposit_id])
      @transfer        = TimeDeposits::TransferProcessing.new(transfer_params)
      if @transfer.valid?
        @transfer.process!
        redirect_to time_deposit_transfer_voucher_url(time_deposit_id: @time_deposit.id, id: @transfer.find_voucher.id)
      else
        render :new, status: :unprocessable_entity
      end
    end

    private
    def transfer_params
      params.require(:time_deposits_transfer_processing).
      permit(:time_deposit_id, :saving_id, :account_number, :date, :employee_id, :cooperative_id, :description, :reference_number)
    end
  end
end
