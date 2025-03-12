module TreasuryModule
  module CashAccounts
    class CashDisbursementLineItemCancellationsController < ApplicationController
      def create
        @cash_account = current_office.accounts.find(params[:cash_account_id])
        @amount       = current_cart.voucher_amounts.find(params[:id])
        ApplicationRecord.transaction do
          @amount.destroy
          TreasuryModule::CashAccounts::TotalCashAccountUpdater.new(cash_account: @cash_account, cart: current_cart).update_amount!
        end
        redirect_to new_treasury_module_cash_account_cash_disbursement_line_item_url(@cash_account), notice: "removed successfully"
      end
    end
  end
end
