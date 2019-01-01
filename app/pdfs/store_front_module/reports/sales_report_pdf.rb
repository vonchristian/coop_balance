module StoreFrontModule
  module Reports
    class SalesReportPdf < Prawn::Document
      attr_reader :employee, :sales_orders, :from_date, :to_date, :view_context, :cooperative, :store_front
      def initialize(args)
        super(margin: 30, page_size: "A4", page_layout: :portrait)
        @employee     = args.fetch(:employee, nil)
        @sales_orders = args.fetch(:sales_orders)
        @from_date    = args.fetch(:from_date)
        @to_date      = args.fetch(:to_date)
        @view_context = args.fetch(:view_context)
        @cooperative  = @employee.cooperative
        @store_front  = @employee.store_front
        @cash_account = args[:cash_account]
        heading
        summary
        sales_table
      end

      private
      def price(number)
        view_context.number_to_currency(number, :unit => "P ")
      end
      def heading
        bounding_box [300, 770], width: 50 do
          image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 50, height: 50
        end
        bounding_box [360, 770], width: 200 do
            text "#{cooperative.abbreviated_name }", style: :bold, size: 18
            text "#{cooperative.name.try(:upcase)}", size: 7
            text "#{cooperative.address}", size: 7
        end
        bounding_box [0, 770], width: 400 do
          text "SALES REPORT", style: :bold, size: 12
          text "Date Covered: #{from_date.strftime("%b. %e, %Y")} - #{to_date.strftime("%b. %e, %Y")}", size: 10
          text "#{store_front.name}"
        end
        move_down 15
        stroke do
          stroke_color '24292E'
          line_width 1
          stroke_horizontal_rule
          move_down 10
        end
      end
      def summary
        bounding_box [0, 700], width: 200 do
          text "SALE SUMMARY", size: 10, style: :bold, color: '0069D9'
          table([["CASH SALES", "#{sales_orders.total}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 100]) do
            cells.borders = []
            column(1).font_style = :bold
          end
          table([["CREDIT SALES", "#{sales_orders.total}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 100]) do
            cells.borders = []
            column(1).font_style = :bold
          end
        end
        bounding_box [300, 700], width: 235 do
          text "CASH ON HAND", size: 10, style: :bold, color: '0069D9'
          table([["Beginning Balance", "#{sales_orders.total}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 100]) do
            cells.borders = []
            column(1).font_style = :bold
          end
          table([["Add Cash Sales", "#{sales_orders.total}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 100]) do
            cells.borders = []
            column(1).font_style = :bold
          end
          table([["Less Disbursements", "#{sales_orders.total}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 100]) do
            cells.borders = []
            column(1).font_style = :bold
          end
          stroke do
            stroke_color '24292E'
            line_width 0.5
            stroke_horizontal_rule
            move_down 5
          end
          table([["Ending Balance", "#{sales_orders.total}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 100]) do
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
      def sales_table
        text "SALES TRANSACTIONS", size: 10, style: :bold, color: '0069D9'
        move_down 5
        table([["DATE", "CUSTOMER", "REF #", "AMOUNT", "TOTAL"]], cell_style: { padding: [2,2], inline_format: true, size: 10}, column_widths: [80, 150, 50, 100, 100]) do
        end
      end
    end
  end
end
