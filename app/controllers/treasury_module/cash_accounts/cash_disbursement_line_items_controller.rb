module TreasuryModule
  module CashAccounts
    class CashDisbursementLineItemsController < ApplicationController
      def new
        @cash_account = AccountingModule::Account.find(params[:cash_account_id])
        @disbursement_line_item = TreasuryModule::CashDisbursementLineItemProcessing.new
        @disbursement = Vouchers::DisbursementProcessing.new
      end
      def create
        @cash_account = AccountingModule::Account.find(params[:cash_account_id])
        @disbursement_line_item = TreasuryModule::CashDisbursementLineItemProcessing.new(disbursement_params)
        if @disbursement_line_item.valid?
          @disbursement_line_item.save
          redirect_to new_treasury_module_cash_account_cash_disbursement_line_item_url(@cash_account), notice: "Added successfully"
        else
          render :new
        end
      end
      def destroy
        @cash_account = AccountingModule::Account.find(params[:cash_account_id])
        @amount = Vouchers::VoucherAmount.find(params[:amount_id])
        @amount.destroy
        redirect_to new_treasury_module_cash_account_cash_disbursement_line_item_url(@cash_account), notice: "removed successfully"
      end

      private
      def disbursement_params
        params.require(:treasury_module_cash_disbursement_line_item_processing).
        permit(:amount, :account_id, :description, :employee_id, :cash_account_id)
      end
    end
  end
end
