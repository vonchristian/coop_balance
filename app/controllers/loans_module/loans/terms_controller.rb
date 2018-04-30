module LoansModule
  module Loans
    class TermsController < ApplicationController
      def new
        @loan = LoansModule::Loan.find(params[:loan_id])
        @term_extension = LoansModule::Loans::Term.new
      end
      def create
        @loan = LoansModule::Loan.find(params[:loan_id])
        @term_extension = LoansModule::Loans::Term.new(term_params)
        if @term_extension.valid?
          @term_extension.extend!
          redirect_to loan_url(@loan), notice: "Loan term extension saved successfully."
        else
          render :new
        end
      end

      private
      def term_params
        params.require(:loans_module_loans_term).
        permit(:term, :loan_id, :employee_id, :effectivity_date)
      end
    end
  end
end
