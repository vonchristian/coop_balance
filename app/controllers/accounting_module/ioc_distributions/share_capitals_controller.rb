module AccountingModule
  module IocDistributions
    class ShareCapitalsController < ApplicationController
      def new 
        @pagy, @share_capitals  = pagy(current_office.share_capitals)
        @pagy, @voucher_amounts = pagy(current_cart.voucher_amounts)
        @pagy, @share_capitals_with_payments = pagy(current_office.share_capitals.where(id: AccountingModule::IocDistributions::IocToShareCapitalFinder.new(cart: current_cart).share_capital_ids))
        @voucher = AccountingModule::IocDistributions::ShareCapitalVoucher.new 
      end 

      def destroy 
        @share_capital = current_office.share_capitals.find(params[:id])
        current_cart.voucher_amounts.where(account_id: @share_capital.equity_account_id).destroy_all 
        redirect_to new_accounting_module_ioc_distributions_share_capital_url, alert: "removed successfully."
      end 
    end 
  end 
end 