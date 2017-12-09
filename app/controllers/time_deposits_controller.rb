class TimeDepositsController < ApplicationController
  def index
    if params[:search].present?
      @time_deposits = MembershipsModule::TimeDeposit.text_search(params[:search]).paginate(page: params[:page], per_page: 20)
    else
      @time_deposits = MembershipsModule::TimeDeposit.all.paginate(page: params[:page], per_page: 20)
    end
  end
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
  def show
    @time_deposit = MembershipsModule::TimeDeposit.find(params[:id])
  end

  private
  def time_deposit_params
    params.require(:time_deposit_form).permit(:account_number, :or_number, :amount, :date, :member_id, :number_of_days, :payment_type)
  end
end
