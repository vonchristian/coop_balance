module Employees 
  class SavingsAccountsController < ApplicationController
    def index 
      @employee = User.find(params[:employee_id])
    end
    def new 
      @employee = User.find(params[:employee_id])
      @savings_account = Employees::SavingsAccountForm.new
      authorize [:employees, :savings_account]
    end 
    def create
      @employee = User.find(params[:employee_id])      
      @saving = Employees::SavingsAccountForm.new(saving_params)
      if @saving.valid?
        @saving.save
        redirect_to employee_url(@employee), notice: "Savings Account opened successfully."
      else
        render :new
      end
    end

    private
    def saving_params
      params.require(:employees_savings_account_form).permit(:recorder_id, :account_number, :saving_product_id, :depositor_id, :depositor_type, :or_number, :date, :amount)
    end
  end 
end 