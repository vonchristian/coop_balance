require 'prawn/qrcode'
module Members
  class SalesOrdersPdf < Prawn::Document
    attr_reader :member, :sales_orders, :view_context

    def initialize(args)
      super(margin: 30, page_size: 'A4', page_layout: :portrait)
      @member       = args.fetch(:member)
      @sales_orders = args.fetch(:sales_orders)
      @view_context = args.fetch(:view_context)

      sales_orders_details
    end

    private

    def sales_orders_details
      text 'SALES ORDERS DETAILS'
      if @member.sales_orders.present?
        table(sales_orders_data) do
          cells.borders = []
        end
      else
        'NO DATA AVAILABLE'
      end
    end

    def sales_orders_data
      @purchases_data = @member.sales_orders.map { |a| [a.date.strftime('%B %e, %Y'), a.total_cost] }
    end
  end
end
