module AccountingModule
  module Entries
    module EntryLineItemVouchers
      class ConfirmationsController < ApplicationController
        def create
          @voucher = current_cooperative.vouchers.find(params[:entry_line_item_voucher_id])
          Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user).process!
          redirect_to accounting_module_entries_url, notice: 'Entry saved successfully.'
        end
      end
    end
  end
end
