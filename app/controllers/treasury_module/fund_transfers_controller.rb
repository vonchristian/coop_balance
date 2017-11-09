module TreasuryModule
  class FundTransfersController < ApplicationController
    def new
       @employee = current_user
      @entry = TreasuryModule::FundTransferForm.new
    end
    def create
      @employee = current_user
      @entry = TreasuryModule::FundTransferForm.new(remittance_params)
      if @entry.valid?
        @entry.save
        redirect_to employee_url(@employee), notice: "Remittance saved successfully."
      else
        render :new
      end
    end

    private
    def remittance_params
      params.require(:treasury_module_fund_transfer_form).permit(:recorder_id, :commercial_document_id, :amount, :debit_account_id, :credit_account_id, :entry_date, :description, :reference_number, :entry_type)
    end
  end
end
