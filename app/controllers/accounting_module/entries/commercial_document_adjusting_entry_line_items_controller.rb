module AccountingModule
  module Entries
    class CommercialDocumentAdjustingEntryLineItemsController < ApplicationController
      def new
        @line_item = AccountingModule::Entries::VoucherAmountProcessing.new
        @voucher = Vouchers::VoucherProcessing.new
        @commercial_document = params[:commercial_document_type].constantize.find(params[:commercial_document_id])
      end

      def create
        @commercial_document = params[:accounting_module_entries_voucher_amount_processing][:commercial_document_type].constantize.find(params[:accounting_module_entries_voucher_amount_processing][:commercial_document_id])
        @line_item = AccountingModule::Entries::VoucherAmountProcessing.new(amount_params)
        if @line_item.valid?
          @line_item.process!
          redirect_to new_accounting_module_commercial_document_adjusting_entry_line_item_url(commercial_document_id: @commercial_document.id, commercial_document_type: @commercial_document.class.to_s), notice: "Added successfully"
        else
          render :new
        end
      end
      def destroy
        @commercial_document = params[:commercial_document_type].constantize.find(params[:commercial_document_id])
        @amount = current_cooperative.voucher_amounts.find(params[:id])
        @amount.destroy
        redirect_to new_accounting_module_commercial_document_adjusting_entry_line_item_url(
          commercial_document_id: @commercial_document.id, 
          commercial_document_type: @commercial_document.class.to_s
        ), notice: "removed successfully"
      end
      private
      def amount_params
        params.require(:accounting_module_entries_voucher_amount_processing).
        permit(:commercial_document_id, :commercial_document_type, :amount, :account_id, :description, :amount_type, :employee_id)
      end
    end
  end
end
