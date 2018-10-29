module AccountingModule
  class EntryProcessingsController < ApplicationController
    def create
      @entry = Vouchers::EntryProcessing.new(entry_params)
      if @entry.valid?
        @entry.disburse!
        redirect_to accounting_module_entries_url, notice: "Adjusting entry saved successfully."
      else
        redirect_to new_accounting_module_entry_line_item_url, alert: "Error"
      end
    end
    private
    def entry_params
      params.require(:vouchers_disbursement_processing).permit(:reference_number, :date, :description, :employee_id, :payee_id)
    end
  end
end
