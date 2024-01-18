module Employees
  class RemittancesController < ApplicationController
    def new
      @employee = current_cooperative.users.find(params[:employee_id])
      @entry = AccountingModule::RemittanceForm.new
    end

    def create
      @employee = current_cooperative.users.find(params[:employee_id])
      @entry = AccountingModule::RemittanceForm.new(remittance_params)
      if @entry.save
        @entry.save
        redirect_to employee_url(@employee), notice: 'Entry saved successfully.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def remittance_params
      params.require(:accounting_module_remittance_form).permit(:recorder_id, :amount, :entry_date, :description, :reference_number, :remitted_to_id)
    end
  end
end
