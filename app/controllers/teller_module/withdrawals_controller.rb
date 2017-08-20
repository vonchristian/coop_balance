module TellerModule
  class WithdrawalsController < ApplicationController
    def new
      @saving = MembershipsModule::Saving.find(params[:savings_account_id])
      @withdrawal = WithdrawalForm.new
    end
    def create
      @saving = MembershipsModule::Saving.find(params[:savings_account_id])
      @withdrawal = WithdrawalForm.new(withdrawal_params)
      if @withdrawal.valid? && @withdrawal.amount_is_less_than_balance
        @withdrawal.save
        redirect_to teller_module_savings_account_path(@saving), notice: "Withdraw transaction saved successfully"
      else 
        render :new, alert: "Amount exceeded balance"
      end
    end

    private
    def withdrawal_params
      params.require(:withdrawal_form).permit(:amount, :or_number, :date, :saving_id, :recorder_id)
    end
  end
end
