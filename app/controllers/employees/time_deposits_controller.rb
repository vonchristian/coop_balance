module Employees
  class TimeDepositsController < ApplicationController
    def index
      @employee = User.find(params[:employee_id])
      @time_deposits = @employee.time_deposits
    end
    def new
      @employee = User.find(params[:employee_id])
      @time_deposit = Memberships::TimeDeposits::DepositProcessing.new
    end
    def create
      @employee = User.find(params[:employee_id])
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
