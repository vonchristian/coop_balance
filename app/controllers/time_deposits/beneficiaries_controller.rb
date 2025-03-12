module TimeDeposits
  class BeneficiariesController < ApplicationController
    respond_to :html, :json

    def edit
      @time_deposit = current_cooperative.time_deposits.find(params[:time_deposit_id])
      respond_modal_with @time_deposit
    end

    def update
      @time_deposit = current_cooperative.time_deposits.find(params[:time_deposit_id])
      @time_deposit.update(time_deposit_params)
      respond_modal_with @time_deposit,
                         location: time_deposit_url(@time_deposit)
    end

    private

    def time_deposit_params
      params.require(:memberships_module_time_deposit).permit(:beneficiaries)
    end
  end
end
