module Members 
  class ShareCapitalsController < ApplicationController
    def index 
      @member = Member.friendly.find(params[:member_id])
      @share_capitals = @member.share_capitals
    end 
    def new
    @member = Member.friendly.find(params[:member_id])
    @share_capital = @member.share_capitals.build
  end
  def create
    @member = Member.friendly.find(params[:member_id])
    @share_capital = @member.share_capitals.create(share_capital_params)
    if @share_capital.save
      redirect_to member_share_capitals_url(@member), notice: "Success"
    else
      render :new
    end
  end

  private
  def share_capital_params
    params.require(:memberships_module_share_capital).permit(:date_opened, :account_number, :share_capital_product_id)
  end
  end 
end 