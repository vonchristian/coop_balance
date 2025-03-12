module Employees
  class VaultFundTransfersController < ApplicationController
    def new
      @employee = current_cooperative.users.find(params[:employee_id])
      @entry = TreasuryModule::VaultFundTransferProcessing.new
    end

    def create
      @employee = current_cooperative.users.find(params[:employee_id])
      @entry = TreasuryModule::VaultFundTransferProcessing.new(remittance_params)
      if @entry.valid?
        @entry.save
        redirect_to employee_url(@employee), notice: "Fund transfer saved successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def remittance_params
      params.require(:treasury_module_vault_fund_transfer_processing)
            .permit(
              :employee_id,
              :amount,
              :credit_account_id,
              :entry_date,
              :description,
              :reference_number
            )
    end
  end
end
