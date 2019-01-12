module LoansModule
  module LoanApplications
    class CapitalBuildUpProcessingsController < ApplicationController
      respond_to :html, :json

      def new
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @share_capital = current_cooperative.share_capitals.find(params[:share_capital_id])
        @capital_build_up = LoansModule::LoanApplications::CapitalBuildUpProcessing.new
        respond_modal_with @capital_build_up
      end
      
      def create
        @loan_application =current_cooperative.loan_applications.find(params[:loans_module_loan_applications_capital_build_up_processing][:loan_application_id])
        @share_capital = current_cooperative.share_capitals.find(params[:loans_module_loan_applications_capital_build_up_processing][:share_capital_id])
        @capital_build_up = LoansModule::LoanApplications::CapitalBuildUpProcessing.new(capital_build_up_params)
        @capital_build_up.process!
        respond_modal_with @capital_build_up,
          location: new_loans_module_loan_application_voucher_url(@loan_application)
      end

      private
      def capital_build_up_params
        params.require(:loans_module_loan_applications_capital_build_up_processing).
        permit(:amount, :employee_id, :loan_application_id, :share_capital_id)
      end
    end
  end
end
