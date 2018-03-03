module Members
  class ShareCapitalsController < ApplicationController
    def index
      @member = Member.friendly.find(params[:member_id])
      @share_capitals = @member.share_capitals
    end
    def new
      @member = Member.friendly.find(params[:member_id])
      @share_capital = ShareCapitalForm.new
    end
    def create
      @member = Member.friendly.find(params[:member_id])
      @share_capital = ShareCapitalForm.new(share_capital_params)
      if @share_capital.save
        redirect_to member_share_capitals_url(@member), notice: "Success"
      else
        render :new
      end
    end

    private
    def share_capital_params
      params.require(:members_share_capital_form).
      permit(:account_number, :subscriber_id, :subscriber_type, :amount, :date, :reference_number, :recorder_id, :share_capital_product_id)
    end
  end
end
