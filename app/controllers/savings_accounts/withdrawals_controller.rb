module SavingsAccounts
  class WithdrawalsController < ApplicationController
    def new
      authorize %i[savings_accounts withdrawal]

      @savings_account = current_office.savings.find(params[:savings_account_id])
      @withdrawal = Memberships::SavingsAccounts::WithdrawalLineItemProcessing.new
    end

    def create
      authorize %i[savings_accounts withdrawal]
      @savings_account = current_office.savings.find(params[:savings_account_id])
      @withdrawal = Memberships::SavingsAccounts::WithdrawalLineItemProcessing.run(withdrawal_params)
      if @withdrawal.valid?
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
