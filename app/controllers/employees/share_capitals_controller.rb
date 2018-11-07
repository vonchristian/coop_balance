module Employees
  class ShareCapitalsController < ApplicationController
    def index
      @employee = current_cooperative.users.find(params[:employee_id])
    end
    def new
      @employee = current_cooperative.users.find(params[:employee_id])
      @share_capital = ShareCapitals::Opening.new
    end
    def create
      @employee = current_cooperative.users.find(params[:employee_id])
      @share_capital = ShareCapitals::Opening.new(share_capital_params)
      if @share_capital.subscribe!
        redirect_to share_capital_url(@share_capital.find_share_capital), notice: "Share capital subscribed successfully."
      else
        render :new
      end
    end

    private
    def share_capital_params
      params.require(:share_capitals_opening).
      permit(
        :account_number,
        :subscriber_id,
        :description,
        :amount,
        :date,
        :reference_number,
        :employee_id,
        :share_capital_product_id)
    end
  end
end
