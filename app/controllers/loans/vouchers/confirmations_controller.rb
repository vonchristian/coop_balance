module Loans
  module Vouchers
    class ConfirmationsController < ApplicationController
      def create
        @voucher = current_cooperative.vouchers.find(params[:voucher_id])
        @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
        Vouchers::EntryProcessing.new(updateable: @loan, voucher: @voucher, employee: current_user).process!
        redirect_to loan_url(@loan), notice: "Confirmed successfully."
      end
    end
  end
end
