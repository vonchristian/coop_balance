module Members
  class TimeDepositsController < ApplicationController
    def index
      @member = Member.find(params[:member_id])
      @time_deposits = @member.time_deposits
    end
    def new
      @member = Member.find(params[:member_id])
      @time_deposit = Memberships::TimeDeposits::DepositProcessing.new
    end

    def create
      @member = Member.find(params[:member_id])
      @time_deposit = Memberships::TimeDeposits::DepositProcessing.new(time_deposit_params)
      if @time_deposit.valid?
        @time_deposit.susbscribe!
        redirect_to time_deposit_url(@time_deposit.find_time_deposit), notice: "Time deposit saved successfully."
      else
        render :new
      end
    end

    private
    def time_deposit_params
      params.require(:memberships_time_deposits_deposit_processing).
      permit(:employee_id, :amount, :reference_number, :date, :depositor_id, :account_number, :term, :time_deposit_product_id)
    end
  end
end
