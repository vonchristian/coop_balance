module LoansModule
  module LoanApplications
    class CapitalBuildUpProcessingsController < ApplicationController
      def new
        @loan_application = LoansModule::LoanApplication.find(params[:loan_application_id])
        @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
        @capital_build_up = LoansModule::LoanApplications::CapitalBuildUpProcessing.new
      end
      def create
        @loan_application = LoansModule::LoanApplication.find(params[:loans_module_loan_applications_capital_build_up_processing][:loan_application_id])
        @share_capital = MembershipsModule::ShareCapital.find(params[:loans_module_loan_applications_capital_build_up_processing][:share_capital_id])
        @capital_build_up = LoansModule::LoanApplications::CapitalBuildUpProcessing.new(capital_build_up_params)
        if @capital_build_up.valid?
          @capital_build_up.process!
          redirect_to loans_module_loan_application_url(@loan_application), notice: "Capital Build Up added successfully"
        else
          render :new
        end
      end

      private
      def capital_build_up_params
        params.require(:loans_module_loan_applications_capital_build_up_processing).
        permit(:amount, :employee_id, :loan_application_id, :share_capital_id)
      end
    end
  end
end
