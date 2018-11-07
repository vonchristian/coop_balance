module ShareCapitalApplications
  class VoucherDisbursementsController < ApplicationController
    def create
      @share_capital_application = current_cooperative.share_capital_applications.find(params[:share_capital_application_id])
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      ActiveRecord::Base.transaction do
        @opening = ShareCapitals::Opening.new(share_capital_application: @share_capital_application, employee: current_user, voucher: @voucher).process!
        Vouchers::EntryProcessing.new(updateable: @opening.find_share_capital, voucher: @voucher, employee: current_user).process!
        redirect_to share_capital_url(@opening.find_share_capital, notice: "Share capital account successfully."
      end
    end
  end
end
