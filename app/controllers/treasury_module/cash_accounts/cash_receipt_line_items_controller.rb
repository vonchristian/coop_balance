module TreasuryModule
  module CashAccounts
    class CashReceiptLineItemsController < ApplicationController
      def new
        @cash_account = current_cooperative.accounts.find(params[:cash_account_id])
        @cash_receipt_line_item = Vouchers::VoucherAmountProcessing.new
        @cash_receipt = Vouchers::VoucherProcessing.new
        authorize [:treasury_module, :cash_receipt]
      end
      def create
        @cash_account = current_cooperative.accounts.find(params[:cash_account_id])
        @cash_receipt_line_item = Vouchers::VoucherAmountProcessing.new(cash_receipt_params)
        authorize [:treasury_module, :cash_receipt]
        if @cash_receipt_line_item.valid?
          @cash_receipt_line_item.save
          redirect_to new_treasury_module_cash_account_cash_receipt_line_item_url(cash_account_id: @cash_account.id), notice: "Added successfully"
        else
          render :new
        end
      end
      def destroy
        @cash_account = current_cooperative.accounts.find(params[:id])
        @amount = current_cooperative.voucher_accounts.find(params[:amount_id])
        @amount.destroy
        redirect_to new_treasury_module_cash_account_cash_receipt_line_item_url(@cash_account), notice: "removed successfully"
      end

      private
      def cash_receipt_params
        params.require(:vouchers_voucher_amount_processing).
        permit(:amount, :account_id, :description, :employee_id, :cash_account_id, :account_number, :amount_type)
      end

    end
  end
end
