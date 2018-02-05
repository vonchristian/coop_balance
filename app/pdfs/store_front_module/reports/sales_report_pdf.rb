module StoreFrontModule
  module Reports
    class SalesReportPdf < Prawn::Document
      def initialize(sales_orders, from_date, to_date, view_context)
        super(margin: 30, page_size: "A4", page_layout: :portrait)
        @sales_orders = sales_orders
        @from_date    = from_date
        @to_date      = to_date
        @view_context = view_context
        heading
        summary
      end

      private
      def price(number)
        @view_context.number_to_currency(number, :unit => "P ")
      end
      def heading
        bounding_box [300, 780], width: 50 do
          image "#{Rails.root}/app/assets/images/logo_kcmdc.jpg", width: 50, height: 50
        end
        bounding_box [370, 780], width: 200 do
            text "KCMDC", style: :bold, size: 24
            text "Kiangan Community Multipurpose Development Cooperative", size: 10
        end
        bounding_box [0, 780], width: 400 do
          text "SALES REPORT", style: :bold, size: 12
          if @from_date == @to_date
            text "DATE: #{@to_date.strftime("%B %e, %Y")}", size: 10
          else
            text "FROM: #{@from_date.strftime("%B %e, %Y")}", size: 10
            text "TO: #{@to_date.strftime("%B %e, %Y")}", size: 10
          end
        end
        stroke do
          move_down 30
          stroke_color '24292E'
          line_width 1
          stroke_horizontal_rule
          move_down 10
        end
      end
      def summary
        bounding_box [0, 700], width: 200 do
          text "SUMMARY:"
          table([["CASH SALES", "#{@sales_orders.total}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 100]) do
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
          table([["Less Disbursements", "#{@sales_orders.total}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 100]) do
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
    end
  end
end
