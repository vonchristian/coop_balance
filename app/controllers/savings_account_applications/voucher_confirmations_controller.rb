module SavingsAccountApplications
  class VoucherConfirmationsController < ApplicationController
    def create
      @savings_account_application = current_cooperative.savings_account_applications.find(params[:savings_account_application_id])
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      ActiveRecord::Base.transaction do
        Savings::Opening.new(savings_account_application: @savings_account_application, employee: current_user, voucher: @voucher).open_account!
        Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user).process!
        @savings_account = current_cooperative.savings.find_by(account_number: @savings_account_application.account_number)

        BalanceStatusChecker.new(account: @savings_account, product: @savings_account.saving_product).set_balance_status

        redirect_to savings_account_url(@savings_account), notice: 'Savings account opened successfully.'
      end
    end
  end
end
