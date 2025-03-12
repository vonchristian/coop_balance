module LoansModule
  module Loans
    class ArchivingsController < ApplicationController
      def create
        @loan = current_cooperative.loans.find(params[:loan_id])
        @loan.update(
          archived: true,
          archiving_date: Time.zone.today,
          archived_by: current_user
        )

        redirect_to loan_url(@loan), notice: "Loan archived successfully."
      end
    end
  end
end
