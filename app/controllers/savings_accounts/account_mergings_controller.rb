module SavingsAccounts
  class AccountMergingsController < ApplicationController
    def new
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @merging = SavingsAccounts::AccountMerging.new
    end
    def create
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @merging = SavingsAccounts::AccountMerging.new(merging_params)
      if @merging.valid?
        @merging.merge!
        redirect_to savings_account_url(@savings_account), notice: "Account merged successfully."
      else
        render :new
      end
    end

    private
    def merging_params
      params.require(:savings_accounts_account_merging).
      permit(:mergee_id, :merger_id)
    end
  end
end

