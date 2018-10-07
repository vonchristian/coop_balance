module TimeDeposits
  class AdjustingEntriesController < ApplicationController
    def new
      @time_deposit = MembershipsModule::TimeDeposit.find(params[:time_deposit_id])
      @entry = AccountingModule::AdjustingEntry.new
    end

    def create
      @time_deposit = MembershipsModule::TimeDeposit.find(params[:time_deposit_id])
      @entry = AccountingModule::AdjustingEntry.new(adjusting_entry_params)
      if @entry.valid?
        @entry.save
        redirect_to time_deposit_url(@time_deposit), notice: "Adjusting Entry saved successfully."
      else
        render :new
      end
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
