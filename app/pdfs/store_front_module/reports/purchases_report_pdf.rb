module StoreFrontModule
  module Reports
    class PurchasesReportPdf < Prawn::Document
      def initialize(purchase_orders, from_date, to_date, view_context)
        super(margin: 30, page_size: "A4", page_layout: :portrait)
        @purchase_orders = purchase_orders
        @from_date    = from_date
        @to_date      = to_date
        @view_context = view_context
        heading
        summary
        purchase_details
      end

      private

      def price(number)
        @view_context.number_to_currency(number, unit: "P ")
      end

      def heading
        bounding_box [ 300, 780 ], width: 50 do
          image Rails.root.join("app/assets/images/kccmc_logo.jpg").to_s, width: 50, height: 50
        end
        bounding_box [ 370, 780 ], width: 200 do
          text "KCCMC", style: :bold, size: 24
          text "Tinoc Community Multipurpose Development Cooperative", size: 10
        end
        bounding_box [ 0, 780 ], width: 400 do
          text "PURCHASES REPORT", style: :bold, size: 12
          if @from_date == @to_date
            text "DATE: #{@to_date.strftime('%B %e, %Y')}", size: 10
          else
            text "FROM: #{@from_date.strftime('%B %e, %Y')}", size: 10
            text "TO: #{@to_date.strftime('%B %e, %Y')}", size: 10
          end
        end
        stroke do
          move_down 30
          stroke_color "24292E"
          line_width 1
          stroke_horizontal_rule
          move_down 10
        end
      end

      def summary
        bounding_box [ 0, 700 ], width: 200 do
          text "SUMMARY:"
          table([ [ "CASH PURCHASES", price(@purchase_orders.processed.sum(&:total_cost)).to_s ] ], header: true, cell_style: { size: 14, font: "Helvetica" }, column_widths: [ 100, 100 ]) do
            cells.borders = []
            column(1).font_style = :bold
          end
        end
        stroke do
          move_down 10
          stroke_color "24292E"
          line_width 1
          stroke_horizontal_rule
          move_down 10
        end
        def purchase_details
          @purchase_orders.processed.each do |purchase_order|
            next if purchase_order.line_items.blank?

            table([ [ purchase_order.date.try(:strftime, "%B %e, %Y").to_s, purchase_order.supplier_name.try(:upcase).to_s ] ]) do
              cells.borders = []
            end

            purchase_order.line_items.each do |line_item|
              table([ [ line_item.quantity,
                      line_item.unit_of_measurement_code,
                      line_item.name,
                      price(line_item.unit_cost),
                      price(line_item.total_cost) ] ], cell_style: { size: 10, font: "Helvetica" }, column_widths: [ 100, 50, 150, 100, 100 ]) do
                column(3).align = :right
                column(2).align = :right
              end
            end
            table([ [ "", "", "", "TOTAL", purchase_order.total_cost.to_s ] ], cell_style: { size: 10, font: "Helvetica" }, column_widths: [ 100, 50, 150, 100, 100 ]) do
              column(3).align = :right
              column(2).align = :right
            end
          end
        end

        def purchases_data(purchase_order)
          @purchases_data ||= purchase_order.products.distinct.map { |e| [ purchase_order.line_items.count, "#{purchase_order.line_items_quantity(e)} #{e.base_measurement_code}", e.name, price(e.base_measurement_price), price(purchase_order.line_items_total_cost(e)) ] }
        end
      end
    end
  end
end
