module TimeDeposits
  class WithdrawalsController < ApplicationController
    def new
      @time_deposit = current_office.time_deposits.find(params[:time_deposit_id])
      @withdrawal   = TimeDeposits::WithdrawalLineItemProcessing.new
    end

    def create
      @time_deposit = current_office.time_deposits.find(params[:time_deposit_id])
      @withdrawal   = TimeDeposits::WithdrawalLineItemProcessing.new(withdrawal_params)
      if @withdrawal.valid?
        @withdrawal.process!
        redirect_to time_deposit_withdrawal_voucher_url(time_deposit_id: @time_deposit.id, id: @withdrawal.find_voucher.id), notice: 'Voucher created successfully'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def withdrawal_params
      params.require(:time_deposits_withdrawal_line_item_processing).permit(:or_number, :date, :time_deposit_id, :employee_id, :account_number, :amount, :interest, :cash_account_id)
    end
  end
end
