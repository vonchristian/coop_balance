module AccountingModule
  module IocDistributions
    class LoanVoucherConfirmationsController < ApplicationController
      def create
        @voucher = current_office.vouchers.find(params[:voucher_id])
        ApplicationRecord.transaction do
          Vouchers::EntryProcessing.new(updateable: @share_capital, voucher: @voucher, employee: current_user).process!
        end

        redirect_to accounting_module_ioc_distributions_url, notice: "Transaction confirmed successfully."
      end
    end
  end
end
