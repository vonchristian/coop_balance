module StoreFrontModule
  module Reports
    class PurchasesReportsController < ApplicationController
      def index
        if params[:from_date].present? && params[:to_date].present?
          @from_date = Chronic.parse(params[:from_date])
          @to_date = Chronic.parse(params[:to_date])
          @purchase_orders = StoreFrontModule::Orders::PurchaseOrder.ordered_on(from_date: @from_date, to_date: @to_date)
        end
        respond_to do |format|
          format.html
          format.pdf do
            pdf = StoreFrontModule::Reports::PurchasesReportPdf.new(@purchase_orders, @from_date, @to_date, view_context)
            send_data pdf.render, type: 'application/pdf', disposition: 'inline', file_name: 'Purchase Orders Report.pdf'
          end
        end
      end
    end
  end
end
