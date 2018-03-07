module TreasuryModule
  class DisbursementProcessingsController < ApplicationController
    def create
      @disbursement = DisbursementProcessing.new(disbursement_params)
      if @disbursement.valid?
        @disbursement.disburse!
        redirect_to treasury_module_disbursements_url, notice: "Disbursement saved successfully."
      else
        redirect_to new_treasury_module_disbursement_line_item_url, alert: "Error"
      end
    end
    private
    def disbursement_params
      params.require(:disbursement_processing).permit(:reference_number, :date, :description, :employee_id, :payee_id)
    end
  end
end
