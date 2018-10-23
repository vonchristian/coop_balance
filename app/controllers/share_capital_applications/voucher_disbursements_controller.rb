module ShareCapitalApplications
  class VoucherDisbursementsController < ApplicationController
    def create
      @share_capital_application = ShareCapitalApplication.find(params[:share_capital_application_id])
      @voucher = Voucher.find(params[:voucher_id])
      ActiveRecord::Base.transaction do
        ShareCapitals::Opening.new(share_capital_application: @share_capital_application, employee: current_user, voucher: @voucher).process!
        Vouchers::DisbursementProcessing.new(voucher_id: @voucher.id, employee_id: current_user.id).process!
        redirect_to vouchers_url, notice: "Voucher disbursed successfully."
      end
    end
  end
end
