module SavingsAccounts
  class WithdrawalsController < ApplicationController
    def new
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @withdrawal = WithdrawalForm.new
    end
    def create
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @withdrawal = WithdrawalForm.new(withdrawal_params)
      if @withdrawal.valid? && @withdrawal.amount_is_less_than_balance
        @withdrawal.save
        redirect_to savings_account_path(@savings_account), notice: "Withdraw transaction saved successfully"
      else 
         render :new
      end
    end

    private
    def withdrawal_params
      params.require(:withdrawal_form).permit(:amount, :or_number, :date, :saving_id, :recorder_id)
    end
  end
end