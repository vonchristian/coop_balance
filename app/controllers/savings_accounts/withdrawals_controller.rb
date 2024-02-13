# frozen_string_literal: true

module SavingsAccounts
  class WithdrawalsController < ApplicationController
    def new
      authorize %i[savings_accounts withdrawal]

      @savings_account = current_office.savings.find(params[:savings_account_id])
      @withdrawal = SavingsAccounts::WithdrawInitiation.new(savings_account: @savings_account, employee: current_user)
    end

    def create
      authorize %i[savings_accounts withdrawal]

      @savings_account = current_office.savings.find(params[:savings_account_id])
      @withdrawal = SavingsAccounts::WithdrawInitiation.run(withdrawal_params.merge!(savings_account: @savings_account, employee: current_user))
      if @withdrawal.valid?
        redirect_to savings_account_withdrawal_voucher_url(savings_account_id: @savings_account.id, id: @withdrawal.result.id), notice: 'Withdraw transaction initiated.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def withdrawal_params
      params.require(:savings_accounts_withdraw_initiation)
            .permit(:amount, :or_number, :date, :cash_account_id, :account_number, :description)
    end
  end
end
