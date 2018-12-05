module AccountingModule
  module Entries
    class EntryLineItemVouchersController < ApplicationController
      def create
        @voucher = Vouchers::VoucherProcessing.new(voucher_params)
        if @voucher.valid?
          @voucher.process!
          redirect_to accounting_module_entry_line_item_voucher_url(id: @voucher.find_voucher.id), notice: "Voucher created successfully."
        else
          redirect_to new_accounting_module_entry_line_item_url, alert: "Error"
        end
      end

      def show
        @voucher = current_cooperative.vouchers.find(params[:id])
      end

      private
      def voucher_params
        params.require(:vouchers_voucher_processing).permit(:cash_account_id, :reference_number, :date, :description, :employee_id, :payee_id, :cooperative_service_id, :account_number)
      end
    end
  end
end