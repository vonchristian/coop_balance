module TimeDeposits
  class AdjustingEntriesController < ApplicationController
    respond_to :html, :json

    def new
      @time_deposit = MembershipsModule::TimeDeposit.find(params[:time_deposit_id])
      @entry = AccountingModule::AdjustingEntry.new
      respond_modal_with @entry
    end

    def create
      @time_deposit = MembershipsModule::TimeDeposit.find(params[:time_deposit_id])
      @entry = AccountingModule::AdjustingEntry.new(adjusting_entry_params).save
      respond_modal_with @entry, location: time_deposit_settings_url(@time_deposit), 
          notice: "Adjusting Entry saved successfully."
    end

    private
    def adjusting_entry_params
      params.require(:accounting_module_adjusting_entry).
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
