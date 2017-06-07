class TimeDepositsController < ApplicationController
  def new
    @member = Member.find(params[:member_id])
    @time_deposit = TimeDepositForm.new
  end
  def create
    @member = Member.find(params[:member_id])
    @time_deposit = TimeDepositForm.new(time_deposit_params)
    if @time_deposit.valid?
      @time_deposit.save
      redirect_to "/", notice: "Success"
    else
      render :new
    end
  end

  private
  def time_deposit_params
    params.require(:time_deposit_form).permit(:account_number, :or_number, :amount, :date, :member_id)
  end
end
