module SavingsAccounts
  class AccountMergingsController < ApplicationController
    def create
      @savings_account = current_cooperative.savings.find(params[:savings_account_id])
      @merging = SavingsAccounts::AccountMerging.new(merging_params)
      @merging.merge!
      redirect_to savings_account_url(@savings_account), notice: 'Account merged successfully.'
    end

    private

    def merging_params
      params.require(:savings_accounts_account_merging)
            .permit(:cart_id, :saving_id)
    end
  end
end

