module StoreFrontModule
  module Reports
    class SalesClerkSalesReportsController < ApplicationController
      def index
        @employee = User.find(params[:employee_id])
        @from_date = Chronic.parse(params[:from_date])
        @to_date = Chronic.parse(params[:to_date])
        @sales_orders = @employee.sold_orders.ordered_on(from_date: @from_date, to_date: @to_date)
        respond_to do |format|
          format.html
          format.pdf do
            pdf = StoreFrontModule::Reports::SalesClerk::SalesReportPdf.new(@employee, @sales_orders, @from_date, @to_date, view_context)
            send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "Sales Order.pdf"
          end
        end
      end
    end
  end
end
