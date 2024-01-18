module LoansModule
  module Loans
    class OrganizationsController < ApplicationController
      respond_to :html, :json

      def edit
        @loan = current_cooperative.loans.find(params[:loan_id])
        respond_modal_with @loan
      end

      def update
        @loan = current_cooperative.loans.find(params[:loan_id])
        @loan.update(organization_params)
        respond_modal_with @loan, location: loan_settings_url(@loan), notice: 'Loan organization updated successfully.'
      end

      private

      def organization_params
        params.require(:loans_module_loan)
              .permit(:organization_id)
      end
    end
  end
end
