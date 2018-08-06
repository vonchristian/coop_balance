module LoansModule
  module Loans
    class ArchivingsController < ApplicationController
      def create
        @loan = LoansModule::Loan.find(params[:loan_id])
        @loan.update_attributes!(
          archived: true,
          archiving_date: Date.today,
          archived_by: current_user)

        redirect_to loan_url(@loan), notice: "Loan archived successfully."
      end
    end
  end
end
