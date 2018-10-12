module TellerModule
  class CapitalBuildUpsController < ApplicationController
    def new
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
      @capital_build_up = CapitalBuildUpForm.new
    end
    def create
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
      @capital_build_up = CapitalBuildUpForm.new(share_capital_params)
      if @capital_build_up.valid?
        @capital_build_up.save
        redirect_to teller_module_member_url(@share_capital.account_owner), notice: "Success"
      else
        render :new
      end
    end

    private
    def share_capital_params
      params.require(:capital_build_up_form).permit(:share_capital_id, :share_count, :or_number, :amount, :recorder_id, :cash_account_id)
    end
  end
end
