module ShareCapitalApplications
  class VoucherDisbursementsController < ApplicationController
    def create
      @share_capital_application = current_cooperative.share_capital_applications.find(params[:share_capital_application_id])
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      ActiveRecord::Base.transaction do
        create_share_capital
        @share_capital = current_cooperative.share_capitals.find_by(account_number: @share_capital_application.account_number)
        disburse_voucher
        set_balance_status
        redirect_to share_capital_url(id: @share_capital.id), notice: "Share capital account opened successfully."
      end
    end

    private

    def create_share_capital
      ShareCapitals::Opening.new(share_capital_application: @share_capital_application, employee: current_user, voucher: @voucher).process!
    end

    def disburse_voucher
      Vouchers::EntryProcessing.new(updateable: @share_capital, voucher: @voucher, employee: current_user).process!
    end

    def set_balance_status
      BalanceStatusChecker.new(account: @share_capital, product: @share_capital.share_capital_product).set_balance_status
    end
  end
end
