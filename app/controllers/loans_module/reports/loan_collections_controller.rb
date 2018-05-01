module LoansModule
  module Reports
    class LoanCollectionsController < ApplicationController
      def index
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : DateTime.now.at_beginning_of_month
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : DateTime.now
        @collections = AccountingModule::Entry.loan_payments(from_date: @from_date, to_date: @to_date)
        respond_to do |format|
          format.html
          format.pdf do
            pdf = LoansModule::Reports::LoanCollectionsPdf.new(@collections, @from_date, @to_date, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Loan Collections Report.pdf"
          end
        end
      end
    end
  end
end
