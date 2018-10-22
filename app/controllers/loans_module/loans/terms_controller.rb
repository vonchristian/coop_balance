module LoansModule
  module Loans
    class TermsController < ApplicationController
      respond_to :html, :json

      def new
        @loan = LoansModule::Loan.find(params[:loan_id])
        @term_extension = LoansModule::Loans::Term.new
        respond_modal_with @term_extension
      end

      def create
        @loan = LoansModule::Loan.find(params[:loan_id])
        @term_extension = LoansModule::Loans::Term.new(term_params)
        @term_extension.extend!
        respond_modal_with @term_extension, location: loan_settings_url(@loan), notice: "Loan term extension saved successfully."
      end

      private
      def term_params
        params.require(:loans_module_loans_term).
        permit(:term, :loan_id, :employee_id, :effectivity_date)
      end
    end
  end
end
