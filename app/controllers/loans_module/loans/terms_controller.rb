module LoansModule
  module Loans
    class TermsController < ApplicationController
      respond_to :html, :json

      def new
        @loan = current_cooperative.loans.find(params[:loan_id])
        @term = LoansModule::Loans::TermProcessing.new
      end

      def create
        @loan = current_cooperative.loans.find(params[:loan_id])
        @term = LoansModule::Loans::TermProcessing.new(term_params)
        if @term.valid?
          @term.process!
          redirect_to loan_settings_url(@loan), notice: "Loan term saved successfully."
        else
          render :new, status: :unprocessable_entity
        end
      end

      private

      def term_params
        params.require(:loans_module_loans_term_processing)
              .permit(:number_of_days, :loan_id, :employee_id, :effectivity_date)
      end
    end
  end
end
