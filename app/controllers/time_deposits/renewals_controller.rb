module TimeDeposits 
  class RenewalsController < ApplicationController
    def new 
      @time_deposit = MembershipsModule::TimeDeposit.find(params[:time_deposit_id])
      @renewal = TimeDeposits::RenewalForm.new 
    end 
    def create
      @time_deposit = MembershipsModule::TimeDeposit.find(params[:time_deposit_id])
      @renewal = TimeDeposits::RenewalForm.new(renewal_params)
      if @renewal.valid?
        @renewal.save 
        redirect_to member_time_deposits_url(@time_deposit.depositor), notice: "Time Deposit renewed successfully."
      else 
        render :new 
      end 
    end

    private 
    def renewal_params
      params.require(:time_deposits_renewal_form).permit(:time_deposit_id, :account_number, :or_number, :amount, :date, :member_id, :recorder_id, :number_of_days, :date_deposited)
    end
  end 
end
