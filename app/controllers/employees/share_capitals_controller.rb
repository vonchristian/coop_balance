module Employees 
  class ShareCapitalsController < ApplicationController
    def index 
      @employee = User.find(params[:employee_id])
    end 
    def new 
      @employee = User.find(params[:employee_id])
      @share_capital = Employees::ShareCapitalForm.new 
    end 
    def create 
      @employee = User.find(params[:employee_id])
      @share_capital = Employees::ShareCapitalForm.new(share_capital_params)
      if @share_capital.save 
        redirect_to employee_share_capitals_url(@employee), notice: "Share capital subscribed successfully."
      else 
        render :new 
      end 
    end 

    private 
    def share_capital_params
      params.require(:employees_share_capital_form).permit(:account_number, :subscriber_id, :subscriber_type, :amount, :date, :reference_number, :recorder_id, :share_capital_product_id)
    end
  end 
end 