module Members
  class TimeDepositsController < ApplicationController
    def index
      @member = Member.friendly.find(params[:member_id])
    end
    def new
      @member = Member.friendly.find(params[:member_id])
      @time_deposit = TimeDepositForm.new
      authorize [:members, :time_deposit]
    end
    def create
      @member = Member.friendly.find(params[:member_id])
      @time_deposit = TimeDepositForm.new(time_deposit_params)
      authorize [:members, :time_deposit]

      if @time_deposit.valid?
        @time_deposit.save
        redirect_to member_time_deposits_url(@member), notice: "Deposited successfully."
      else
        render :new
      end
    end

    private
    def time_deposit_params
      params.require(:time_deposit_form).permit(:or_number, :amount, :date, :member_id, :recorder_id, :number_of_days, :date_deposited, :time_deposit_product_id, :payment_type)
    end
  end
end
