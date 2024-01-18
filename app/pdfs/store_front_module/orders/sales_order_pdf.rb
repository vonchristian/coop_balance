require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/prawn_outputter'
module StoreFrontModule
  module Orders
    class SalesOrderPdf < Prawn::Document
      TABLE_WIDTHS = [40, 60, 50, 50].freeze
      ORDER_DETAILS_WIDTHS = [20, 20, 15].freeze
      def initialize(sales_order, customer, view_context)
        super(margin: 2, page_size: [204, 792], page_layout: :portrait)
        @sales_order = sales_order
        @customer = customer
        @view_context = view_context
        logo
        # business_details
        # heading
        customer_details
        display_orders_table
        payment_details
        cashier_details
        asterisks
        barcode
      end

      def price(number)
        @view_context.number_to_currency(number, unit: 'P ')
      end

      def logo
        move_down 10
        image Rails.root.join('app/assets/images/kccmc_logo.jpg').to_s, width: 50, height: 50, position: :center
        move_down 5
        text 'Tinoc COMMUNITY MULTIPURPOSE DEVELOPMENT COOPERATIVE', align: :center, size: 8, style: :bold
        text 'Poblacion, Tinoc, Ifugao', size: 7, align: :center
        text 'Email: hmpc@gmail.com', size: 7, align: :center
        text 'Contact No: 999-999-999', size: 7, align: :center
        move_down 4
        stroke do
          stroke_color 'CCCCCC'
          line_width 0.2
          stroke_horizontal_rule
        end
      end

      def customer_details
        table([['CUSTOMER', @sales_order.customer_name.try(:upcase).to_s]], header: true, cell_style: { size: 6, font: 'Helvetica' }, column_widths: [100, 100]) do
          cells.borders = []
          column(1).font_style = :bold
        end
        table([["PURCHASES (#{Time.zone.today.year})", price(@sales_order.commercial_document.total_purchases(fron_date: Time.zone.today.beginning_of_year, to_date: Time.zone.today.end_of_year)).to_s]], header: true, cell_style: { size: 6, font: 'Helvetica' }, column_widths: [100, 100]) do
          cells.borders = []
          column(1).font_style = :bold
        end
        table([['TOTAL CREDIT', price(@sales_order.commercial_document.total_purchases).to_s]], header: true, cell_style: { size: 6, font: 'Helvetica' }, column_widths: [100, 100]) do
          cells.borders = []
        end
      end

      def display_orders_table
        if @sales_order.sales_order_line_items.blank?
          text 'No orders data.', align: :center
        else
          stroke do
            stroke_color 'CCCCCC'
            line_width 0.2
            stroke_horizontal_rule
          end
          table(table_data, header: true, cell_style: { size: 6, font: 'Helvetica' }, column_widths: TABLE_WIDTHS) do
            cells.borders = []
            row(0).font_style = :bold

            column(3).align = :right
            column(4).align = :right
          end
          stroke do
            stroke_color 'CCCCCC'
            line_width 0.2
            stroke_horizontal_rule
          end
        end
      end

      def table_data
        move_down 5
        [%w[QTY PRODUCT COST TOTAL]] +
          @table_data ||= @sales_order.products.distinct.map { |e| ["#{@sales_order.line_items_quantity(e)} #{e.base_measurement_code}", e.name, price(e.base_measurement_price), price(@sales_order.line_items_total_cost(e))] }
      end

      def payment_details
        text 'Total', size: 6
        text 'Cash Tendered', size: 6
        text 'Change', size: 6
        text 'VAT Sales', size: 6
        text '12% EVAT', size: 6
        text 'NONVAT Sales', size: 6
        stroke do
          stroke_color 'CCCCCC'
          line_width 0.2
          stroke_horizontal_rule
        end
      end

      def cashier_details
        text "Cashier: #{@sales_order.employee_name}"
        text @sales_order.date.strftime('%b, %e, %Y %H:%m %p').to_s
      end

      def asterisks
        move_down 10
        stroke_horizontal_rule
        move_down 10
        return if @sales_order.reference_number.blank?

        text 'THIS SERVES AS YOUR OFFICIAL RECEIPT', size: 7, align: :center, style: :bold
        barcode.annotate_pdf(self, height: 25, x: 5, y: cursor - 30)
        move_down 32
      end

      def barcode; end
    end
  end
end
