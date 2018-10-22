module Loans
  class BarangaysController < ApplicationController
    respond_to :html, :json

    def edit
      @loan = LoansModule::Loan.find(params[:id])
      respond_modal_with @loan
    end

    def update
      @loan = LoansModule::Loan.find(params[:id])
      @loan.update(loan_params)
      respond_modal_with @loan, location: loan_settings_path(@loan), notice: "Barangay updated successfully."
    end

    private
    def loan_params
      params.require(:loans_module_loan).permit(:barangay_id)
    end
  end
end
