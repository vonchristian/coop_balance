class ShareCapitalsController < ApplicationController
  def index
    @member = Member.find(params[:member_id])
  end
  def new
    @member = Member.find(params[:member_id])
    @share_capital = @member.share_capitals.build
  end
  def create
    @member = Member.find(params[:member_id])
    @share_capital = @member.share_capitals.create(share_capital_params)
    if @share_capital.save
      redirect_to teller_module_member_url(@member), notice: "Success"
    else
      render :new
    end
  end

  private
  def share_capital_params
    params.require(:memberships_module_share_capital).permit(:date_opened, :account_number, :share_capital_product_id)
  end
end
