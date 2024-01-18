module TreasuryModule
  module CashAccounts
    class CashReceiptLineItemsController < ApplicationController
      def new
        @cash_account = current_user.cash_accounts.find(params[:cash_account_id])
        @receipt_line_item = TreasuryModule::CashAccounts::ReceiptLineItem.new
        @receipt = Vouchers::VoucherProcessing.new
        @voucher_amounts = current_cart.voucher_amounts.includes(:account)
        authorize %i[treasury_module cash_receipt]

        if params[:payee_type] && params[:payee_id]
          @payee = params[:payee_type].constantize.find_by(id: params[:payee_id])

          current_cart.update(customer: @payee)
        end

        @pagy, @payees = pagy(current_office.member_memberships.text_search(params[:payee_search])) if params[:payee_search]

        @account = current_office.accounts.find_by(id: params[:account_id]) if params[:account_id].present?

        return if params[:search].blank?

        @account = current_office.accounts.find_by(id: params[:account_id])
        @pagy, @accounts = pagy(current_office.accounts.text_search(params[:search]))
      end

      def create
        @cash_account           = current_user.cash_accounts.find(params[:cash_account_id])
        @cash_receipt_line_item = TreasuryModule::CashAccounts::ReceiptLineItem.new(cash_receipt_params)
        @cash_receipt           = Vouchers::VoucherProcessing.new
        @voucher_amounts        = current_cart.voucher_amounts.includes(:account)

        authorize %i[treasury_module cash_receipt]
        if @cash_receipt_line_item.valid?
          @cash_receipt_line_item.process!
          redirect_to new_treasury_module_cash_account_cash_receipt_line_item_url(cash_account_id: @cash_account.id), notice: 'Added successfully'
        else
          render :new, status: :unprocessable_entity
        end
      end

      def destroy
        @cash_account = current_cooperative.accounts.find(params[:id])
        @amount = current_cooperative.voucher_amounts.find(params[:amount_id])
        @amount.destroy
        redirect_to new_treasury_module_cash_account_cash_receipt_line_item_url(@cash_account), notice: 'removed successfully'
      end

      private

      def cash_receipt_params
        params.require(:treasury_module_cash_accounts_receipt_line_item)
              .permit(:amount, :account_id, :description, :employee_id, :cash_account_id, :account_number, :cart_id)
      end
    end
  end
end
