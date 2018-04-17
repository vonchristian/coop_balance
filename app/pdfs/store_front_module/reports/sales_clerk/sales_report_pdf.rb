module StoreFrontModule
  module Reports
    module SalesClerk
      class SalesReportPdf < Prawn::Document
        def initialize(employee,sales_orders, sales_return_orders, from_date, to_date, view_context)
          super(margin: 30, page_size: "A4", page_layout: :portrait)
          @employee     = employee
          @sales_orders = sales_orders
          @sales_return_orders = sales_return_orders
          @from_date    = from_date
          @to_date      = to_date
          @view_context = view_context
          heading
          summary
          order_details
          sales_return_order_details
        end

        private
        def price(number)
          @view_context.number_to_currency(number, :unit => "P ")
        end
        def heading
          bounding_box [300, 780], width: 50 do
            image "#{Rails.root}/app/assets/images/kccmc_logo.jpg", width: 50, height: 50
          end
          bounding_box [370, 780], width: 200 do
              text "KCCMC", style: :bold, size: 24
              text "Tinoc Community Multipurpose Development Cooperative", size: 10
          end
          bounding_box [0, 780], width: 400 do
            text "SALES REPORT", style: :bold, size: 12
            if @from_date == @to_date
              text "DATE: #{@to_date.strftime("%B %e, %Y")}", size: 10
            else
              text "FROM: #{@from_date.strftime("%B %e, %Y")}", size: 10
              text "TO: #{@to_date.strftime("%B %e, %Y")}", size: 10
            end
            move_down 5
            text "EMPLOYEE: #{@employee.first_and_last_name.try(:upcase)}", size: 10, style: :bold
          end
          stroke do
            move_down 10
            stroke_color '24292E'
            line_width 1
            stroke_horizontal_rule
            move_down 10
          end
        end
        def summary
          bounding_box [0, 700], width: 200 do
            text "SUMMARY:"
            table([["CASH SALES", "#{@sales_orders.cash_sales.sum(&:total_cost)}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 100]) do
              cells.borders = []
              column(1).font_style = :bold
            end
            table([["CREDIT SALES", "#{@sales_orders.credit_sales.sum(&:total_cost)}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 100]) do
              cells.borders = []
              column(1).font_style = :bold
            end
            table([["TOTAL SALES", "#{@sales_orders.total}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 100]) do
              cells.borders = []
              column(1).font_style = :bold
            end
            table([["INCOME", "#{price(@sales_orders.total_income)}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 100]) do
              cells.borders = []
              column(1).font_style = :bold
            end
          end
          bounding_box [300, 700], width: 235 do
            text "CASH ON HAND:"
            table([["Beginning Balance", "#{@sales_orders.total}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 100]) do
              cells.borders = []
              column(1).font_style = :bold
            end
            table([["Add Cash Sales", "#{@sales_orders.total}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 100]) do
              cells.borders = []
              column(1).font_style = :bold
            end
            table([["Less Remittances", "#{@sales_orders.total}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 100]) do
              cells.borders = []
              column(1).font_style = :bold
            end
            stroke do
              stroke_color '24292E'
              line_width 0.5
              stroke_horizontal_rule
              move_down 5
            end
            table([["Ending Balance", "#{@sales_orders.total}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 100]) do
              cells.borders = []
              column(1).font_style = :bold
            end

          end
          stroke do
            move_down 10
            stroke_color '24292E'
            line_width 1
            stroke_horizontal_rule
            move_down 10
          end
        end
        def order_details
          text "SALES", style: :bold, size: 12
          table(orders_data, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [130, 200, 105, 100]) do
            row(0).font_style = :bold
            column(2).align = :right
            column(3).align = :right

          end
        end
        def orders_data
          [["DATE", "CUSTOMER", "TOTAL COST", "INCOME"]] +
          @orders_data ||= @sales_orders.map{|order| [order.date.strftime("%B %e, %Y"), order.customer_name, price(order.total_cost), price(order.income)]}
        end

        def sales_return_order_details
          move_down 10
          text "SALES RETURNS", style: :bold, size: 12
          table(sales_return_orders_data, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [130, 200, 105, 100]) do
            row(0).font_style = :bold
            column(2).align = :right
            column(3).align = :right

          end
        end
        def sales_return_orders_data
          [["DATE", "CUSTOMER", "TOTAL COST", "REMARKS"]] +
          @sales_return_orders_data ||= @sales_return_orders.map{|order| [order.date.strftime("%B %e, %Y"), order.customer_name, price(order.total_cost), order.note_content]}
        end
      end
    end
  end
end
