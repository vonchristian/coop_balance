module ShareCapitals
  module Vouchers
    class ConfirmationsController < ApplicationController
      def create
        @voucher = current_cooperative.vouchers.find(params[:voucher_id])
        @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
        SavingsAccounts::VoucherProcessing.new(voucher_id: @voucher.id).process!
        redirect_to share_capital_url(@share_capital), notice: "Confirmed successfully."
      end
    end
  end
end
