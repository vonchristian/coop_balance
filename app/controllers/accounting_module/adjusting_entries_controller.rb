module AccountingModule
  class AdjustingEntriesController < ApplicationController
    def new
      @entry = AccountingModule::AdjustingEntry.new
    end

    def create
      @entry = AccountingModule::AdjustingEntry.new(adjusting_entry_params)
      if @entry.valid?
        @entry.save
        redirect_to accounting_module_entries_url, notice: "Adjusting Entry saved successfully."
      else
        render :new
      end
    end

    private
    def adjusting_entry_params
      params.require(:vouchers_voucher_processing).
      permit(:entry_date,
             :employee_id,
             :reference_number,
             :description,
             :amount,
             :debit_account_id,
             :credit_account_id,
             :commercial_document_id,
             :commercial_document_type)
    end
  end
end
