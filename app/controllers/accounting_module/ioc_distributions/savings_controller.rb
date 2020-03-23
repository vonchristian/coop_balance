module AccountingModule
  module IocDistributions
    class SavingsController < ApplicationController
      def new 
        @pagy, @savings               = pagy(current_office.savings)
        @pagy, @voucher_amounts       = pagy(current_cart.voucher_amounts)
        @pagy, @savings_with_payments = pagy(current_office.savings.where(id: AccountingModule::IocDistributions::IocToSavingFinder.new(cart: current_cart).saving_ids))
        @voucher = AccountingModule::IocDistributions::IocVoucher.new 
      end 

      def destroy 
        @saving = current_office.savings.find(params[:id])
        current_cart.voucher_amounts.where(account_id: @saving.liability_id).destroy_all 
        redirect_to new_accounting_module_ioc_distributions_saving_url, alert: "removed successfully."
      end 
    end 
  end 
end 