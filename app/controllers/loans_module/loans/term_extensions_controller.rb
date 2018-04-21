module LoansModule
  module Loans
    class TermExtensionsController < ApplicationController
      def new
        @loan = LoansModule::Loan.find(params[:loan_id])
        @term_extension = LoansModule::Loans::TermExtension.new
      end
      def create
        @loan = LoansModule::Loan.find(params[:loan_id])
        @term_extension = LoansModule::Loans::TermExtension.new(term_extension_params)
        if @term_extension.valid?
          @term_extension.extend!
          redirect_to loan_url(@loan), notice: "Loan term extension saved successfully."
        else
          render :new
        end
      end

      private
      def term_extension_params
        params.require(:loans_module_loans_term_extension).
        permit(:number_of_months, :loan_id, :employee_id, :date)
      end
    end
  end
end
