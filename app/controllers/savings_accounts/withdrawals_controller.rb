module SavingsAccounts
  class WithdrawalsController < ApplicationController
    def new
      @savings_account = current_office.savings.find(params[:savings_account_id])
      @withdrawal = Memberships::SavingsAccounts::WithdrawalLineItemProcessing.new
      authorize %i[savings_accounts withdrawal]
    end

    def create
      @savings_account = current_office.savings.find(params[:savings_account_id])
      @withdrawal = Memberships::SavingsAccounts::WithdrawalLineItemProcessing.new(withdrawal_params)
      authorize %i[savings_accounts withdrawal]
      if @withdrawal.valid?
        @withdrawal.save
        redirect_to savings_account_withdrawal_voucher_url(savings_account_id: @savings_account.id, id: @withdrawal.find_voucher.id), notice: 'Withdraw transaction created successfully.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def withdrawal_params
      params.require(:memberships_savings_accounts_withdrawal_line_item_processing)
            .permit(:amount, :or_number, :date, :saving_id, :employee_id, :cash_account_id, :account_number, :description)
    end
  end
end
