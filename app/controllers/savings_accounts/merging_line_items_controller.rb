module SavingsAccounts
  class MergingLineItemsController < ApplicationController
    def new
      @current_saving = current_cooperative.savings.find(params[:savings_account_id])
      @merging_line_item = Carts::SavingMergingProcessing.new
      @savings_accounts = if params[:search].present?
                            current_cooperative.savings.text_search(params[:search]).paginate(page: params[:page], per_page: 10)
                          else
                            @current_saving.depositor.savings.except(@current_saving)
                          end
      @merging = SavingsAccounts::AccountMerging.new
    end

    def create
      @current_saving = current_cooperative.savings.find(params[:savings_account_id])
      @merging_line_item = Carts::SavingMergingProcessing.new(saving_params)
      @merging_line_item.save
      redirect_to new_savings_account_merging_line_item_url(@current_saving), notice: 'Savings account selected successfully.'
    end

    def destroy
      @current_saving = current_cooperative.savings.find(params[:current_saving_id])
      @saving = current_cooperative.savings.find(params[:saving_id])
      @saving.cart_id = nil
      @saving.save
      redirect_to new_savings_account_merging_line_item_url(@current_saving), notice: 'Removed successfully.'
    end

    private

    def saving_params
      params.require(:carts_saving_merging_processing)
            .permit(:cart_id, :old_saving_id)
    end
  end
end
