module ShareCapitalApplications
  class VoucherDisbursementsController < ApplicationController
    def create
      @share_capital_application = current_cooperative.share_capital_applications.find(params[:share_capital_application_id])
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      ActiveRecord::Base.transaction do
        ShareCapitals::Opening.new(share_capital_application: @share_capital_application, employee: current_user, voucher: @voucher).process!
        @share_capital = current_cooperative.share_capitals.find_by(account_number: @share_capital_application.account_number)
        Vouchers::EntryProcessing.new(updateable: @share_capital, voucher: @voucher, employee: current_user).process!
        redirect_to share_capital_url(id: @share_capital.id), notice: "Share capital account opened successfully."
      end
    end
  end
end
