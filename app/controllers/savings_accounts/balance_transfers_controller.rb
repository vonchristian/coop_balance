module SavingsAccounts
  class BalanceTransfersController < ApplicationController
    def new
      @origin_saving = current_office.savings.find(params[:savings_account_id])
      @pagy, @savings_accounts   = pagy(current_office.savings.includes(:saving_product, :liability_account, depositor: [avatar_attachment: [:blob]]))
      @balance_transfer_voucher  = SavingsAccounts::BalanceTransferVoucher.new
    end

    def create
      @origin_saving = current_office.savings.find(params[:savings_account_id])
      @pagy, @savings_accounts   = pagy(current_office.savings.includes(:saving_product, :liability_account, depositor: [avatar_attachment: [:blob]]))
      @balance_transfer_voucher  = SavingsAccounts::BalanceTransferVoucher.new(balance_transfer_params)
      if @balance_transfer_voucher.valid?
        @balance_transfer_voucher.process!
        redirect_to savings_account_balance_transfer_voucher_url(savings_account_id: @origin_saving.id, id: @balance_transfer_voucher.find_voucher.id), notice: 'Voucher created successfully.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def balance_transfer_params
      params.require(:savings_accounts_balance_transfer_voucher)
            .permit(:date, :reference_number, :cart_id, :description, :employee_id, :account_number, :origin_saving_id)
    end
  end
end
