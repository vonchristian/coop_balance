module LoansModule
  module Loans
    class OrganizationsController < ApplicationController
      def edit
        @loan = LoansModule::Loan.find(params[:loan_id])
      end
      def update
        @loan = LoansModule::Loan.find(params[:loan_id])
        @loan.update(organization_params)
        if @loan.valid?
          @loan.save
          redirect_to loan_settings_url(@loan), notice: "Loan organization updated successfully."
        else
          render :edit
        end
      end

      private
      def organization_params
        params.require(:loans_module_loan).
        permit(:organization_id)
      end
    end
  end
end
