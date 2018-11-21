module TreasuryModule
  module CashAccounts
    class CashDisbursementLineItemsController < ApplicationController
      def new
        @cash_account = current_cooperative.accounts.find(params[:cash_account_id])
        @disbursement_line_item = Vouchers::VoucherAmountProcessing.new
        @disbursement = Vouchers::VoucherProcessing.new
        authorize [:treasury_module, :cash_disbursement]
      end
      def create
        @cash_account = current_cooperative.accounts.find(params[:cash_account_id])
        @disbursement_line_item = Vouchers::VoucherAmountProcessing.new(disbursement_params)
        authorize [:treasury_module, :cash_disbursement]
        if @disbursement_line_item.valid?
          @disbursement_line_item.save
          redirect_to new_treasury_module_cash_account_cash_disbursement_line_item_url(@cash_account), notice: "Added successfully"
        else
          render :new
        end
      end
      def destroy
        @cash_account = current_cooperative.accounts.find(params[:cash_account_id])
        @amount = current_cooperative.voucher_accounts.find(params[:amount_id])
        @amount.destroy
        redirect_to new_treasury_module_cash_account_cash_disbursement_line_item_url(@cash_account), notice: "removed successfully"
      end

      private
      def disbursement_params
        params.require(:vouchers_voucher_amount_processing).
        permit(:amount, :account_id, :description, :employee_id, :cash_account_id, :amount_type)
      end
    end
  end
end
