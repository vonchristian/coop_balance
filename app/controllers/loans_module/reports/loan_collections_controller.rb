module LoansModule
  module Reports
    class LoanCollectionsController < ApplicationController
      def index
        @from_date = params[:from_date] ? DateTime.parse(params[:from_date]) : DateTime.now.at_beginning_of_month
        @to_date = params[:to_date] ? DateTime.parse(params[:to_date]) : DateTime.now
        @loan_product = current_cooperative.loan_products.find_by(id: params[:loan_product_id])
        if @loan_product.present?
          @collections = @loan_product.entries.loan_payments.entered_on(from_date: @from_date, to_date: @to_date).order(entry_date: :desc)
        else
          @collections = current_cooperative.loan_products.loan_payment_entries.entered_on(from_date: @from_date, to_date: @to_date).order(entry_date: :desc)
        end
        respond_to do |format|
          format.html
          format.xlsx
          format.pdf do
            pdf = LoansModule::Reports::LoanCollectionsPdf.new(
              collections:  @collections,
              from_date:    @from_date,
              to_date:      @to_date,
              cooperative:  current_cooperative,
              loan_product: @loan_product,
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Loan Collections Report.pdf"
          end
        end
      end
    end
  end
end
