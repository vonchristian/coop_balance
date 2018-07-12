module TreasuryModule
  class DisbursementLineItemsController < ApplicationController
    def new
      @disbursement_line_item = TreasuryModule::CashDisbursementLineItemProcessing.new
      @disbursement = Vouchers::DisbursementProcessing.new
    end
    def create
      @disbursement_line_item = TreasuryModule::CashDisbursementLineItemProcessing.new(disbursement_params)
      if @disbursement_line_item.valid?
        @disbursement_line_item.save
        redirect_to new_treasury_module_disbursement_line_item_url, notice: "Added successfully"
      else
        render :new
      end
    end
    def destroy
      @amount = Vouchers::VoucherAmount.find(params[:id])
      @amount.destroy
      redirect_to new_treasury_module_disbursement_line_item_url, notice: "removed successfully"
    end

    private
    def disbursement_params
      params.require(:treasury_module_cash_disbursement_line_item_processing).
      permit(:amount, :account_id, :description, :employee_id)
    end
  end
end
