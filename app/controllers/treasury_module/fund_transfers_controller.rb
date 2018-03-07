module TreasuryModule
  class FundTransfersController < ApplicationController
    def new
       @employee = current_user
      @entry = TreasuryModule::FundTransferProcessing.new
    end
    def create
      @employee = current_user
      @entry = TreasuryModule::FundTransferProcessing.new(remittance_params)
      if @entry.valid?
        @entry.save
        redirect_to employee_url(@employee), notice: "Remittance saved successfully."
      else
        render :new
      end
    end

    private
    def remittance_params
      params.require(:treasury_module_fund_transfer_processing).
      permit(:employee_id,
        :receiver_id,
        :amount,
        :entry_date,
        :description,
        :reference_number)
    end
  end
end
