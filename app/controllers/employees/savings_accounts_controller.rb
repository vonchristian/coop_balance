module Employees
  class SavingsAccountsController < ApplicationController
    def index
      @employee = User.find(params[:employee_id])
    end
    def new
      @employee = User.find(params[:employee_id])
      @savings_account = SavingForm.new
      authorize [:employees, :savings_account]
    end
    def create
      @employee = User.find(params[:employee_id])
      @savings_account = SavingForm.new(saving_params)
      if @savings_account.valid?
        @savings_account.save
        redirect_to employee_url(@employee), notice: "Savings Account opened successfully."
      else
        render :new
      end
    end

    private
    def saving_params
      params.require(:saving_form).permit(:recorder_id, :account_number, :saving_product_id, :depositor_id, :or_number, :date, :amount)
    end
  end
end
