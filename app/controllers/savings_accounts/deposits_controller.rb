module SavingsAccounts
  class DepositsController < ApplicationController
    def new
      @savings_account = current_office.savings.find(params[:savings_account_id])
      @deposit = Memberships::SavingsAccounts::DepositLineItemProcessing.new
      authorize [:savings_accounts, :deposit]
    end
    def create
      @savings_account = current_office.savings.find(params[:savings_account_id])
      @deposit = Memberships::SavingsAccounts::DepositLineItemProcessing.new(deposit_params)
      authorize [:savings_accounts, :deposit]
      if @deposit.valid?
        @deposit.save
        redirect_to savings_account_deposit_voucher_url(savings_account_id: @savings_account.id, id: @deposit.find_voucher.id), notice: "Savings deposit transaction created successfully."
      else
        render :new
      end
    end

    private
    def deposit_params
      params.require(:memberships_savings_accounts_deposit_line_item_processing).permit(:amount, :or_number, :description, :date, :saving_id, :employee_id, :offline_receipt, :cash_account_id, :account_number)
    end
  end
end
