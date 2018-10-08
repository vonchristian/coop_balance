module LoansModule
  module Reports
    class LoanCollectionsController < ApplicationController
      def index
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : DateTime.now.at_beginning_of_month
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : DateTime.now
        @collections = current_cooperative.loans.loan_payments(from_date: @from_date, to_date: @to_date).uniq
        @organization = current_cooperative.organizations.find(params[:organization_id])
        @cooperative = current_cooperative
        respond_to do |format|
          format.html
          format.pdf do
            pdf = LoansModule::Reports::LoanCollectionsPdf.new(
              collections: @collections,
              from_date: @from_date,
              to_date: @to_date,
              cooperative: @cooperative,
              organization: @organization,
              view_context: @view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Loan Collections Report.pdf"
          end
        end
      end
    end
  end
end
