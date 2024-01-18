module Members
  class ShareCapitalsController < ApplicationController
    def index
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @share_capitals = @member.share_capitals
    end

    def new
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @share_capital = ShareCapitals::Opening.new
    end

    def create
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @share_capital = ShareCapitals::Opening.new(share_capital_params)
      if @share_capital.subscribe!
        redirect_to share_capital_url(@share_capital.find_share_capital), notice: 'Success'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def share_capital_params
      params.require(:share_capitals_opening)
            .permit(:share_capital_product_id,
                    :employee_id,
                    :subscriber_id,
                    :amount,
                    :reference_number,
                    :date,
                    :description,
                    :account_number,
                    :cash_account_id)
    end
  end
end
