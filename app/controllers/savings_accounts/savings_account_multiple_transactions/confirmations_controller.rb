module SavingsAccounts
  module SavingsAccountMultipleTransactions
    class ConfirmationsController < ApplicationController
      def create
        @voucher = current_office.vouchers.find(params[:voucher_id])
        ApplicationRecord.transaction do
          Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user).process!
        end
        redirect_to savings_accounts_url, notice: 'confirmed successfully'
      end
    end
  end
end