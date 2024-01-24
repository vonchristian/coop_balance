module LoansModule
  module LoanApplications
    class CapitalBuildUpsController < ApplicationController
      respond_to :html, :json

      def new
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @share_capital = current_cooperative.share_capitals.find(params[:share_capital_id])
        @capital_build_up = LoansModule::LoanApplications::CapitalBuildUp.new
        respond_modal_with @capital_build_up
      end

      def create
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @share_capital = current_cooperative.share_capitals.find(params[:loans_module_loan_applications_capital_build_up][:share_capital_id])
        @capital_build_up = LoansModule::LoanApplications::CapitalBuildUp.run(capital_build_up_params.merge!(loan_application: @loan_application, share_capital: @share_capital))
        if @capital_build_up.valid?
          redirect_to new_loans_module_loan_application_voucher_url(@loan_application)
        else
          redirect_to new_loans_module_loan_application_voucher_url(@loan_application)
        end
      end

      private

      def capital_build_up_params
        params.require(:loans_module_loan_applications_capital_build_up)
              .permit(:amount)
      end
    end
  end
end
