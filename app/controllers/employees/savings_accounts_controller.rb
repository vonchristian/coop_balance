module Employees
  class SavingsAccountsController < ApplicationController
    def index
      @employee = User.find(params[:employee_id])
    end
    def new
      @employee = User.find(params[:employee_id])
      @savings_account = Memberships::SavingsAccountSubscription.new
      authorize [:employees, :savings_account]
    end
    def create
      @employee = User.find(params[:employee_id])
      @savings_account = Memberships::SavingsAccountSubscription.new(saving_params)
      if @savings_account.valid?
        @savings_account.save
        redirect_to employee_url(@employee), notice: "Savings Account opened successfully."
      else
        render :new
      end
    end

    private
    def saving_params
      params.require(:memberships_savings_account_subscription).
      permit(:employee_id, :account_number, :saving_product_id, :depositor_id, :or_number, :date, :amount)
    end
  end
end
