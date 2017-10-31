module Employees
  class TimeDepositsController < ApplicationController
    def index
      @employee = User.find(params[:employee_id])
      @time_deposits = @employee.time_deposits
    end
    def new
      @employee = User.find(params[:employee_id])
      @time_deposit = Employees::TimeDepositForm.new
    end
    def create
      @employee = User.find(params[:employee_id])
      @time_deposit = Employees::TimeDepositForm.new(time_deposit_params)
      if @time_deposit.valid?
        @time_deposit.save
        redirect_to employee_time_deposits_url(@employee), notice: "Time deposit saved successfully."
      else
        render :new
      end
    end

    private
    def time_deposit_params
      params.require(:employees_time_deposit_form).permit(:recorder_id, :amount, :reference_number, :date, :depositor_id, :depositor_type, :account_number, :number_of_days)
    end
  end
end
