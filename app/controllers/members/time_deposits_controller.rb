module Members 
  class TimeDepositsController < ApplicationController
    def index 
      @member = Member.friendly.find(params[:member_id])
    end 
    def new
      @member = Member.friendly.find(params[:member_id])
      @time_deposit = TimeDepositForm.new
    end
    def create
      @member = Member.friendly.find(params[:member_id])
      @time_deposit = TimeDepositForm.new(time_deposit_params)
      if @time_deposit.valid?
        @time_deposit.save
        redirect_to member_time_deposits_url(@member), notice: "Deposited successfully."
      else
        render :new
      end
    end

    private
    def time_deposit_params
      params.require(:time_deposit_form).permit(:account_number, :or_number, :amount, :date, :member_id, :recorder_id, :number_of_days, :date_deposited)
    end
  end 
end 