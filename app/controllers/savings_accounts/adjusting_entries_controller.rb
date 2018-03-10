module SavingsAccounts
  class AdjustingEntriesController < ApplicationController
    def new
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @entry = AccountingModule::AdjustingEntry.new
    end
    def create
      @savings_account = MembershipsModule::Saving.find(params[:savings_account_id])
      @entry = AccountingModule::AdjustingEntry.new(adjusting_entry_params)
      if @entry.valid?
        @entry.save
        redirect_to savings_account_url(@savings_account), notice: "Adjusting Entry saved successfully."
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
