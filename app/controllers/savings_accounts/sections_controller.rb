module SavingsAccounts
  class SectionsController < ApplicationController
    def edit
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
    end
    def update
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @savings_account.update(savings_account_params)
      if @savings_account.save
        redirect_to savings_account_url(@savings_account), notice: "Savings section updated successfully."
      else
        render :edit
      end
    end

    private
    def savings_account_params
      params.require(:memberships_module_saving).permit(:section_id)
    end
  end
end
