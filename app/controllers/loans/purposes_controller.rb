module Loans
  class PurposesController < ApplicationController
    respond_to :html, :json

    def edit
      @loan = current_cooperative.loans.find(params[:loan_id])
      respond_modal_with @loan
    end

    def update
      @loan = current_cooperative.loans.find(params[:loan_id])
      @loan.update(purpose_params)
      respond_modal_with @loan, location: loan_url(@loan), notice: "Note saved successfully."
    end

    private

    def purpose_params
      params.require(:loans_module_loan).permit(:purpose)
    end
  end
end
