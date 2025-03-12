module SavingsAccounts
  class SavingsAccountMultipleTransactionProcessingsController < ApplicationController
    def create
      @savings_account_multiple_transaction = SavingsAccounts::MultiplePaymentVoucherProcessing.new(voucher_params)
      if @savings_account_multiple_transaction.valid?
        @savings_account_multiple_transaction.process!
        redirect_to savings_account_multiple_transaction_voucher_url(id: current_office.vouchers.find_by!(account_number: params[:savings_accounts_multiple_payment_voucher_processing][:account_number]).id), notice: "created successfully"
      else
        redirect_to new_savings_accounts_multiple_transaction_url, alert: "Error"
      end
    end

    def show
      @voucher = current_office.vouchers.find(params[:id])
    end

    private

    def voucher_params
      params.require(:savings_accounts_multiple_payment_voucher_processing)
            .permit(:cart_id, :cash_account_id, :employee_id, :date, :reference_number, :description, :account_number)
    end
  end
end
