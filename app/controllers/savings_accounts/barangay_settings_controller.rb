module SavingsAccounts
  class BarangaySettingsController < ApplicationController
    respond_to :html, :json

    def edit
      @savings_account = current_cooperative.savings.find(params[:savings_account_id])
      respond_modal_with @savings_account
    end
    def update
      @savings_account = current_cooperative.savings.find(params[:savings_account_id])
      @savings_account.update(barangay_params)
      respond_modal_with @savings_account,
        location: savings_account_url(@savings_account),
        notice: "Barangay set successfully."
    end

    private
    def barangay_params
      params.require(:memberships_module_saving).
      permit(:barangay_id)
    end
  end
end
