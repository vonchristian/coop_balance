module AccountingModule
  module IocDistributions
    class SavingsController < ApplicationController
      def new 
        if params[:search].present?
          @pagy, @savings             = pagy(current_office.savings.includes(:saving_product, :liability_account, depositor: [:avatar_attachment =>[:blob]]).text_search(params[:search]))
        else 
          @pagy, @savings             = pagy(current_office.savings.includes(:saving_product, :liability_account, depositor: [:avatar_attachment =>[:blob]]))
        end 
        @pagy, @voucher_amounts       = pagy(current_cart.voucher_amounts)
        @pagy, @savings_with_payments = pagy(current_office.savings.where(id: AccountingModule::IocDistributions::IocToSavingFinder.new(cart: current_cart).saving_ids))
        @voucher = AccountingModule::IocDistributions::IocVoucher.new 
      end 

      def destroy 
        @saving = current_office.savings.find(params[:id])
        current_cart.voucher_amounts.where(account_id: @saving.liability_account_id).destroy_all 
        redirect_to new_accounting_module_ioc_distributions_saving_url, alert: "removed successfully."
      end 
    end 
  end 
end 