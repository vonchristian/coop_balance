module Memberships
  class TimeDepositsController < ApplicationController
    def index
      @member = Member.friendly.find(params[:member_id])
    end
    def new
      @membership = Membership.find(params[:membership_id])
      @time_deposit = TimeDepositForm.new
      authorize [:members, :time_deposit]
    end
    def create
      @membership = Membership.find(params[:membership_id])
      @time_deposit = TimeDepositForm.new(time_deposit_params)
      authorize [:members, :time_deposit]

      if @time_deposit.valid?
        @time_deposit.save
        redirect_to time_deposit_url(@time_deposit.find_deposit), notice: "Time Deposit saved successfully."
      else
        render :new
      end
    end

    private
    def time_deposit_params
      params.require(:time_deposit_form).
      permit(:or_number, :amount, :date, :membership_id, :recorder_id,
      :number_of_days, :date_deposited, :time_deposit_product_id,
      :payment_type, :account_number)
    end
  end
end
