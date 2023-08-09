module ShareCapitals
  class WithdrawalsController < ApplicationController
    def new
      @share_capital = current_office.share_capitals.find(params[:share_capital_id])
      @withdrawal    = ShareCapitals::WithdrawalProcessing.new
    end

    def create
      @share_capital = current_office.share_capitals.find(params[:share_capital_id])
      @withdrawal    = ShareCapitals::WithdrawalProcessing.new(withdrawal_params)
      if @withdrawal.valid?
        @withdrawal.process!
        @voucher       = Voucher.find_by(account_number: params[:share_capitals_withdrawal_processing][:account_number])
        
        redirect_to share_capital_withdrawal_voucher_path(share_capital_id: @share_capital.id, id: @voucher.id), notice: 'Withdrawal voucher created successfully.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private
    def withdrawal_params
      params.require(:share_capitals_withdrawal_processing).
      permit(:share_capital_id, :date, :reference_number, :description, :amount, :cash_account_id, :employee_id, :account_number)
    end
  end
end
