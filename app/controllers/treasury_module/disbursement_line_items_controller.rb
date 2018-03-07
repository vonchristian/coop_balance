module TreasuryModule
  class DisbursementLineItemsController < ApplicationController
    def new
      @disbursement_line_item = DisbursementLineItemProcessing.new
      @disbursement = DisbursementProcessing.new
    end
    def create
      @disbursement_line_item = DisbursementLineItemProcessing.new(disbursement_params)
      if @disbursement_line_item.valid?
        @disbursement_line_item.save
        redirect_to new_treasury_module_disbursement_line_item_url, notice: "Added successfully"
      else
        render :new
      end
    end

    private
    def disbursement_params
      params.require(:disbursement_line_item_processing).
      permit(:amount, :account_id, :description, :amount_type, :employee_id)
    end
  end
end
