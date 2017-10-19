module Employees 
  class SavingsAccountsController < ApplicationController
    def new 
      @employee = User.find(params[:employee_id])
      @savings_account = SavingForm.new
    end 
    def create
      @employee = User.find(params[:employee_id])      
      @saving = SavingForm.new(saving_params)
      if @saving.valid?
        @saving.save
        redirect_to employee_url(@employee), notice: "Savings Account opened successfully."
      else
        render :new
      end
    end

    private
    def saving_params
      params.require(:saving_form).permit(:recorder_id, :account_number, :saving_product_id, :depositor_id, :depositor_type, :or_number, :date, :amount)
    end
  end 
end 