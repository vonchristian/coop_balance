module SavingsAccountApplications
  class VoucherConfirmationsController < ApplicationController
    def create
      @savings_account_application = SavingsAccountApplication.find(params[:savings_account_application_id])
      @voucher = Voucher.find(params[:voucher_id])
      ActiveRecord::Base.transaction do
        SavingsAccounts::Opening.new(savings_account_application: @savings_account_application, employee: current_user, voucher: @voucher).process!
        Vouchers::DisbursementProcessing.new(voucher_id: @voucher.id, employee_id: current_user.id).process!
        redirect_to vouchers_url, notice: "confirmed successfully."
      end
    end
  end
end
