module SavingsAccounts
  class WithdrawalsController < ApplicationController
    def new
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @withdrawal = WithdrawalForm.new
      authorize [:savings_accounts, :withdrawal]
    end
    def create
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @withdrawal = WithdrawalForm.new(withdrawal_params)
      authorize [:savings_accounts, :withdrawal]
      if @withdrawal.valid?
        @withdrawal.save
        redirect_to savings_account_path(@savings_account), notice: "Withdraw transaction saved successfully."
      else
         render :new
      end
    end

    private
    def withdrawal_params
      params.require(:withdrawal_form).permit(:amount, :or_number, :date, :saving_id, :recorder_id, :payment_type)
    end
  end
end
