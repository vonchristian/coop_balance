module AccountingModule
  module Entries
    class ReversalVoucherConfirmationsController < ApplicationController
      def create
        @entry = current_office.entries.find(params[:entry_id])
        @voucher = current_office.vouchers.find(params[:voucher_id])
        ActiveRecord::Base.transaction do
          Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user).process!
        end
        redirect_to accounting_module_entry_url(@voucher.entry), notice: 'Reversal entry saved successfully.'
      end
    end
  end
end
