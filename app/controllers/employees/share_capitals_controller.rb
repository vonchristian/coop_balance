module Employees
  class ShareCapitalsController < ApplicationController
    def index
      @employee = User.find(params[:employee_id])
    end
    def new
      @employee = User.find(params[:employee_id])
      @share_capital = Memberships::ShareCapitalSubscription.new
    end
    def create
      @employee = User.find(params[:employee_id])
      @share_capital = Memberships::ShareCapitalSubscription.new(share_capital_params)
      if @share_capital.subscribe!
        redirect_to share_capital_url(@share_capital.find_share_capital), notice: "Share capital subscribed successfully."
      else
        render :new
      end
    end

    private
    def share_capital_params
      params.require(:memberships_share_capital_subscription).
      permit(
        :account_number,
        :subscriber_id,
        :amount,
        :date,
        :reference_number,
        :employee_id,
        :share_capital_product_id)
    end
  end
end
