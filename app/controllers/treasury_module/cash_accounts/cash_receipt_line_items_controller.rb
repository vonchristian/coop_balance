module TreasuryModule
  module CashAccounts
    class CashReceiptLineItemsController < ApplicationController
      def new
        @cash_account = AccountingModule::Account.find(params[:cash_account_id])
        @cash_receipt_line_item = Vouchers::VoucherAmountProcessing.new
        @cash_receipt = Vouchers::VoucherProcessing.new
      end
      def create
        @cash_account = AccountingModule::Account.find(params[:cash_account_id])
        @cash_receipt_line_item = Vouchers::VoucherAmountProcessing.new(cash_receipt_params)
        if @cash_receipt_line_item.valid?
          @cash_receipt_line_item.save
          redirect_to new_treasury_module_cash_account_cash_receipt_line_item_url(cash_account_id: @cash_account.id), notice: "Added successfully"
        else
          render :new
        end
      end
      def destroy
        @cash_account = AccountingModule::Account.find(params[:id])
        @amount = Vouchers::VoucherAmount.find(params[:amount_id])
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
