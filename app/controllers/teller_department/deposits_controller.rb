module TellerDepartment
  class DepositsController < ApplicationController
    def new
      @saving = Saving.find(params[:savings_account_id])
      @deposit = DepositForm.new
    end
    def create
      @saving = Saving.find(params[:savings_account_id])
      @deposit = DepositForm.new(deposit_params)
      if @deposit.valid?
        @deposit.save
        redirect_to "/", notice: "Success"
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
