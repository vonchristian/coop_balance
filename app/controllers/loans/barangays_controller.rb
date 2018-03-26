module Loans
  class BarangaysController < ApplicationController
    def edit
      @loan = LoansModule::Loan.find(params[:id])
    end
    def update
      @loan = LoansModule::Loan.find(params[:id])
      @loan.update(loan_params)
      if @loan.valid?
        @loan.save
        redirect_to loan_settings_path(@loan), notice: "Loan updated successfully"
      else
        render :new
      end
    end

    private
    def loan_params
      params.require(:loans_module_loan).permit(:barangay_id)
    end
  end
end
