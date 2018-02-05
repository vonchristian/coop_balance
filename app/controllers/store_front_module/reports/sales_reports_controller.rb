module StoreFrontModule
  module Reports
    class SalesReportsController < ApplicationController
      def index
        @sales_orders = StoreFrontModule::Orders::SalesOrder.all.paginate(page: params[:page], per_page: 30)
        @from_date = Chronic.parse(params[:from_date])
        @to_date = Chronic.parse(params[:to_date])
        respond_to do |format|
          format.html
          format.pdf do
            pdf = StoreFrontModule::Reports::SalesReportPdf.new(@sales_orders, @from_date, @to_date, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Sales Order.pdf"
          end
        end
      end
    end
  end
end
