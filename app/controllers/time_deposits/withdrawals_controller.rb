module TimeDeposits
  class WithdrawalsController < ApplicationController
    def new
      @time_deposit = MembershipsModule::TimeDeposit.find(params[:time_deposit_id])
      @withdrawal = TimeDeposits::WithdrawalForm.new
    end
    def create
      @time_deposit = MembershipsModule::TimeDeposit.find(params[:time_deposit_id])
      @withdrawal = TimeDeposits::WithdrawalForm.new(withdrawal_params)
      if @withdrawal.valid?
        @withdrawal.save
        redirect_to time_deposit_url(@time_deposit), notice: "Time Deposit withdrawn successfully"
      else
        render :new
      end
    end

    private
    def withdrawal_params
      params.require(:time_deposits_withdrawal_form).permit(:or_number, :date, :time_deposit_id, :recorder_id, :amount, :cash_account_id)
    end
  end
end
