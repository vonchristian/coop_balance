module SavingsAccounts
  class DepositsController < ApplicationController
    def new
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @deposit = DepositForm.new
      authorize [:savings_accounts, :deposit]
    end
    def create
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @deposit = DepositForm.new(deposit_params)
      authorize [:savings_accounts, :deposit]

      if @deposit.valid?
        @deposit.save
        redirect_to savings_account_path(@savings_account), notice: "Savings deposit saved successfully"
      else
        render :new
      end
    end

    private
    def deposit_params
      params.require(:deposit_form).permit(:amount, :or_number, :date, :saving_id, :recorder_id, :payment_type)
    end
  end
end
