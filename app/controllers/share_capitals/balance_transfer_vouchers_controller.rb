module ShareCapitals
  class BalanceTransferVouchersController < ApplicationController
    def create
      @share_capital             = current_office.share_capitals.find(params[:share_capital_id])
      @balance_transfer_voucher  = ShareCapitals::BalanceTransferVoucher.new(voucher_params)

      if @balance_transfer_voucher.valid?
        @balance_transfer_voucher.process!
        @voucher = current_office.vouchers.find_by(account_number: params[:share_capitals_balance_transfer_voucher][:account_number])
        redirect_to share_capital_voucher_url(share_capital_id: @share_capital.id, id: @voucher.id), notice: "Voucher created successfully"
      else
        redirect_to new_share_capital_balance_transfer_url(@share_capital), alert: "Error"
      end
    end

    private

    def voucher_params
      params.require(:share_capitals_balance_transfer_voucher)
            .permit(:cart_id, :employee_id, :share_capital_id, :date, :reference_number, :description, :account_number)
    end
  end
end
