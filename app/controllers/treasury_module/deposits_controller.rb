module TreasuryModule 
  class DepositsController < ApplicationController
    def new
      @saving = MembershipsModule::Saving.find(params[:savings_account_id])
      @deposit = DepositForm.new
    end
    def create
      @saving = MembershipsModule::Saving.find(params[:savings_account_id])
      @deposit = DepositForm.new(deposit_params)
      if @deposit.valid?
        @deposit.save
        redirect_to teller_module_savings_account_path(@saving), notice: "Savings deposit saved successfully"
      else
        render :new
      end
    end

    private
    def deposit_params
      params.require(:deposit_form).permit(:amount, :or_number, :date, :saving_id, :recorder_id)
    end
  end
end
