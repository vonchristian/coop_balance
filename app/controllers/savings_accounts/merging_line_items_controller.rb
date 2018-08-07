module SavingsAccounts
  class MergingLineItemsController < ApplicationController
    def new
      @current_saving = MembershipsModule::Saving::find(params[:savings_account_id])
      @merging_line_item = Carts::SavingMergingProcessing.new
      if params[:search].present?
        @savings_accounts = MembershipsModule::Saving.text_search(params[:search]).paginate(page: params[:page], per_page: 10)
      else
        @savings_accounts = @current_saving.depositor.savings.except(@current_saving)
      end
      @merging = SavingsAccounts::AccountMerging.new
    end
    def create
      @current_saving = MembershipsModule::Saving::find(params[:savings_account_id])
      @merging_line_item = Carts::SavingMergingProcessing.new(saving_params)
      @merging_line_item.save
      redirect_to new_savings_account_merging_line_item_url(@current_saving), notice: "Savings account selected successfully."
    end

    def destroy
      @current_saving = MembershipsModule::Saving.find(params[:current_saving_id])
      @saving = MembershipsModule::Saving.find(params[:saving_id])
      @saving.cart_id = nil
      @saving.save
      redirect_to new_savings_account_merging_line_item_url(@current_saving), notice: "Removed successfully."
    end

    private
    def saving_params
      params.require(:carts_saving_merging_processing).
      permit(:cart_id, :old_saving_id)
    end
  end
end
