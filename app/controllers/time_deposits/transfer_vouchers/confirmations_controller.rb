module TimeDeposits
  module TransferVouchers
    class ConfirmationsController < ApplicationController
      def create
        @voucher = current_office.vouchers.find(params[:transfer_voucher_id])
        ActiveRecord::Base.transaction do
          Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user).process!
          redirect_to savings_accounts_url, notice: 'Transaction confirmed successfully.'
        end
      end
    end
  end
end
