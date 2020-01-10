module ShareCapitals
  class ShareCapitalMultipleTransactionProcessingsController < ApplicationController
    def create 
      @share_capital_multiple_transaction = ShareCapitals::MultiplePaymentVoucherProcessing.new(voucher_params)
      if @share_capital_multiple_transaction.valid?
        @share_capital_multiple_transaction.process! 
        redirect_to share_capital_multiple_transaction_voucher_url(id: current_office.vouchers.find_by!(account_number: params[:share_capitals_multiple_payment_voucher_processing][:account_number]).id), notice: 'created successfully'
      else 
        redirect_to new_share_capital_multiple_transaction_url, alert: 'Error'
      end 
    end 

    def show 
      @voucher = current_office.vouchers.find(params[:id])
    end 

    private 
    def voucher_params
      params.require(:share_capitals_multiple_payment_voucher_processing).
      permit(:cart_id, :cash_account_id, :employee_id, :date, :reference_number, :description, :account_number)
    end 
  end 
end 