module StoreFrontModule
  module Reports
    class SalesReportsController < ApplicationController
      def index
        @sales_orders = current_cooperative.sales_orders.paginate(page: params[:page], per_page: 30)
        @from_date    = DateTime.parse(params[:from_date])
        @to_date      = DateTime.parse(params[:to_date])
        respond_to do |format|
          format.html
          format.pdf do
            pdf = StoreFrontModule::Reports::SalesReportPdf.new(
              employee: current_user,
              sales_orders: current_cooperative.sales_orders,
              from_date: @from_date,
              to_date: @to_date,
              view_context: view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Sales Report.pdf"
          end
        end
      end
    end
  end
end
