module TimeDeposits
  module WithdrawalVouchers
    class ConfirmationsController < ApplicationController
      def create
        @time_deposit = current_cooperative.time_deposits.find(params[:time_deposit_id])
        @voucher = current_cooperative.vouchers.find(params[:withdrawal_voucher_id])
        ActiveRecord::Base.transaction do
          Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user).process!
          TimeDeposits::WithdrawalConfirmationProcessing.new(time_deposit: @time_deposit).process!
          redirect_to time_deposit_url(@time_deposit), notice: "Time deposit withdrawn successfully."
        end
      end
    end
  end
end
