module TimeDeposits
  module WithdrawalVouchers
    class ConfirmationsController < ApplicationController
      def create
        @time_deposit = current_office.time_deposits.find(params[:time_deposit_id])
        @voucher = current_office.vouchers.find(params[:withdrawal_voucher_id])
        ActiveRecord::Base.transaction do
          create_entry
          set_time_deposit_as_withdrawn
          redirect_to time_deposit_url(@time_deposit), notice: "Time deposit withdrawn successfully."
        end
      end

      private

      def create_entry
        Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user).process!
      end

      def set_time_deposit_as_withdrawn
        @time_deposit.withdrawn!
      end
    end
  end
end
