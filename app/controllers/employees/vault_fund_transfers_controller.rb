module Employees
  class VaultFundTransfersController < ApplicationController
    def new 
      @employee = User.find(params[:employee_id])
      @entry = AccountingModule::RemittanceForm.new 
    end 
    def create
      @employee = User.find(params[:employee_id])
      @entry = AccountingModule::RemittanceForm.new(remittance_params)
      if @entry.valid?
        @entry.save 
        redirect_to employee_url(@employee), notice: "Remittance saved successfully."
      else 
        render :new 
      end 
    end 

    private 
    def remittance_params
      params.require(:accounting_module_remittance_form).permit(:commercial_document_id, :recorder_id, :user_id, :amount, :debit_account_id, :credit_account_id, :entry_date, :description, :reference_number, :entry_type)
    end 
  end 
end 