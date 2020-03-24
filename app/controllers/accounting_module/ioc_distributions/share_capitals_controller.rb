module AccountingModule
  module IocDistributions
    class ShareCapitalsController < ApplicationController
      def new 
        if params[:search].present?
          @pagy_share_capitals, @share_capitals  = pagy(current_office.share_capitals.includes(:share_capital_product, :share_capital_equity_account, subscriber: [:avatar_attachment =>[:blob]]).text_search(params[:search]))
        else 
          @pagy_share_capitals, @share_capitals  = pagy(current_office.share_capitals.includes(:share_capital_product, :share_capital_equity_account, subscriber: [:avatar_attachment =>[:blob]]))
        end 
        @pagy, @voucher_amounts = pagy(current_cart.voucher_amounts)
        @pagy, @share_capitals_with_payments = pagy(current_office.share_capitals.where(id: AccountingModule::IocDistributions::IocToShareCapitalFinder.new(cart: current_cart).share_capital_ids))
        @voucher = AccountingModule::IocDistributions::IocVoucher.new 
      end 

      def destroy 
        @share_capital = current_office.share_capitals.find(params[:id])
        current_cart.voucher_amounts.where(account_id: @share_capital.equity_account_id).destroy_all 
        redirect_to new_accounting_module_ioc_distributions_share_capital_url, alert: "removed successfully."
      end 
    end 
  end 
end 