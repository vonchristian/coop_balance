module AccountingModule
  module Entries
    class ReversalVouchersController < ApplicationController
      def new
        @entry    = current_office.entries.find(params[:entry_id])
        @reversal = ::AccountingModule::Entries::ReversalVoucherProcessing.new
      end

      def create
        @entry    = current_office.entries.find(params[:entry_id])
        @reversal = ::AccountingModule::Entries::ReversalVoucherProcessing.new(reversal_params)
        if @reversal.valid?
          @reversal.process!
          @voucher = current_office.vouchers.find_by(account_number: params[:accounting_module_entries_reversal_voucher_processing][:account_number])
          redirect_to accounting_module_entry_reversal_voucher_url(entry_id: @entry.id, id: @voucher.id), notice: "Voucher created successfully"
        else
          render :new, status: :unprocessable_entity
        end
      end

      def show
        @entry   = current_office.entries.find(params[:entry_id])
        @voucher = current_office.vouchers.find(params[:id])
      end

      private

      def reversal_params
        params.require(:accounting_module_entries_reversal_voucher_processing)
              .permit(:entry_id, :description, :reference_number, :account_number, :employee_id)
      end
    end
  end
end
