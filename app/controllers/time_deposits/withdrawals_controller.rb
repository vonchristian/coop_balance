module TimeDeposits
  class WithdrawalsController < ApplicationController
    def new
      @time_deposit = MembershipsModule::TimeDeposit.find(params[:time_deposit_id])
      @withdrawal = TimeDeposits::WithdrawalLineItemProcessing.new
    end
    def create
      @time_deposit = MembershipsModule::TimeDeposit.find(params[:time_deposit_id])
      @withdrawal = TimeDeposits::WithdrawalLineItemProcessing.new(withdrawal_params)
      if @withdrawal.valid?
        @withdrawal.process!
        redirect_to voucher_url(id: @withdrawal.find_voucher.id), notice: "Voucher created successfully"
      else
        render :new
      end
    end

    private
    def withdrawal_params
      params.require(:time_deposits_withdrawal_line_item_processing).permit(:or_number, :date, :time_deposit_id, :employee_id, :payment_type, :account_number, :amount, :cash_account_id)
    end
  end
end
