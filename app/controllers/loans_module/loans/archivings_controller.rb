module LoansModule
  module Loans
    class ArchivingsController < ApplicationController
      def create
        @loan = LoansModule::Loan.find(params[:loan_id])
        @loan.archived = true
        @loan.archiving_date = Date.today
        @loan.save
        redirect_to loan_url(@loan), notice: "Loan archived successfully."
      end
    end
  end
end
