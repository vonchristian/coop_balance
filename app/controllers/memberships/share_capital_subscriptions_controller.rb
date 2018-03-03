module Memberships
  class ShareCapitalSubscriptionsController < ApplicationController
    def new
      @membership = Membership.find(params[:membership_id])
      @share_capital = Memberships::ShareCapitalSubscription.new
    end
    def create
      @membership = Membership.find(params[:membership_id])
      @share_capital = Memberships::ShareCapitalSubscription.new(share_capital_params)
      if @share_capital.valid?
        @share_capital.subscribe!
        redirect_to share_capital_url(@share_capital.find_share_capital), notice: "Share Capital saved successfully."
      else
        render :new
      end
    end

    private
    def share_capital_params
      params.require(:memberships_share_capital_subscription).
      permit(:share_capital_product_id, :employee_id, :membership_id, :amount, :reference_number, :date, :account_number)
    end
  end
end
