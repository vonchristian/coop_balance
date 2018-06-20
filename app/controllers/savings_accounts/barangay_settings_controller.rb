module SavingsAccounts
  class BarangaySettingsController < ApplicationController
    def edit
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
    end
    def update
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @savings_account.update(barangay_params)
      if @savings_account.valid?
        @savings_account.save
        redirect_to savings_account_url(@savings_account), notice: "Barangay set successfully."
      else
        render :edit
      end
    end

    private
    def barangay_params
      params.require(:memberships_module_saving).
      permit(:barangay_id)
    end
  end
end
