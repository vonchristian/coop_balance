module Members
  class TimeDepositsController < ApplicationController
    def index
      @member        = current_cooperative.member_memberships.find(params[:member_id])
      @time_deposits = @member.time_deposits
    end
    def new
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @time_deposit = Memberships::TimeDeposits::DepositProcessing.new
    end

    def create
      @member = current_cooperative.member_memberships.find(params[:member_id])
      @time_deposit = Memberships::TimeDeposits::DepositProcessing.new(time_deposit_params)
      if @time_deposit.valid?
        @time_deposit.susbscribe!
        redirect_to voucher_url(id: @time_deposit.find_voucher.id), notice: " Time deposit voucher created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private
    def time_deposit_params
      params.require(:memberships_time_deposits_deposit_processing).
      permit(:employee_id, :amount, :reference_number, :date, :depositor_id, :account_number, :term, :time_deposit_product_id, :cash_account_id, :voucher_account_number)
    end
  end
end
