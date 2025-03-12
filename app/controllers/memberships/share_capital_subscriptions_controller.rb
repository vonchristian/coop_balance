module Memberships
  class ShareCapitalSubscriptionsController < ApplicationController
    def new
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @share_capital = Memberships::ShareCapitalSubscription.new
    end

    def create
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @share_capital = Memberships::ShareCapitalSubscription.new(share_capital_params)
      if @share_capital.valid?
        @share_capital.subscribe!
        redirect_to share_capital_url(@share_capital.find_share_capital), notice: "Share Capital saved successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def share_capital_params
      params.require(:memberships_share_capital_subscription)
            .permit(:share_capital_product_id, :employee_id, :membership_id, :amount, :reference_number, :date, :account_number)
    end
  end
end
