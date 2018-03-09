module Members
  class ShareCapitalsController < ApplicationController
    def index
      @member = Member.find(params[:member_id])
      @share_capitals = @member.share_capitals
    end
    def new
      @member = Member.find(params[:member_id])
      @share_capital = Memberships::ShareCapitalSubscription.new
    end
    def create
      @member = Member.find(params[:member_id])
      @share_capital = Memberships::ShareCapitalSubscription.new(share_capital_params)
      if @share_capital.subscribe!
        redirect_to share_capital_url(@share_capital.find_share_capital), notice: "Success"
      else
        render :new
      end
    end

    private
    def share_capital_params
      params.require(:memberships_share_capital_subscription).
      permit(:description, :account_number, :subscriber_id, :amount, :date, :reference_number, :employee_id, :share_capital_product_id)
    end
  end
end
