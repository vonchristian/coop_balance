module AccountingModule
  module Reports
    class BalanceSheetPdf < Prawn::Document
      def initialize(from_date, to_date, assets, liabilities, equity, view_context)
        super(margin: 40, page_size: "A4", page_layout: :portrait)
        @from_date = from_date
        @to_date = to_date
        @assets = assets
        @liabilities = liabilities
        @equity = equity
        @view_context = view_context
        heading
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
            text "Kiangan Community Multipurpose Cooperative", size: 10
        end
        bounding_box [0, 780], width: 400 do
          text "Balance Sheet Report", style: :bold, size: 14
          move_down 3
          text "#{@to_date.strftime("%B %e, %Y")}", size: 10
          move_down 3
          text "Date Generated: #{Time.zone.now.strftime("%B %e, %Y %H:%M %p")}", size: 8
          move_down 3

          # text "Employee: #{@employee.name}", size: 10
        end
        move_down 15
        stroke do
          stroke_color '24292E'
          line_width 1
          stroke_horizontal_rule
          move_down 20
        end
      end
    end
  end
end
