module SavingsAccountApplications
  class VoucherConfirmationsController < ApplicationController
    def create
      @savings_account_application = current_cooperative.savings_account_applications.find(params[:savings_account_application_id])
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      ActiveRecord::Base.transaction do
        SavingsAccounts::Opening.new(savings_account_application: @savings_account_application, employee: current_user, voucher: @voucher).process!
        Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user).process!
        @savings_account = current_cooperative.savings.find_by(account_number: @savings_account_application.account_number)
        redirect_to savings_account_url(@savings_account), notice: "confirmed successfully."
      end
    end
  end
end
