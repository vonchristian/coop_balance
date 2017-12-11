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
        bounding_box [300, 760], width: 50 do
          image "#{Rails.root}/app/assets/images/logo_kcmdc.jpg", width: 40, height: 40
        end
        bounding_box [350, 760], width: 150 do
            text "KCMDC", style: :bold, size: 22
            text "Poblacion, Kiangan, Ifugao", size: 10
        end
        bounding_box [0, 760], width: 400 do
          text "Balance Sheet", style: :bold, size: 14
          move_down 5
          text "#{@from_date.strftime("%B %e, %Y")} - #{@to_date.strftime("%B %e, %Y")} ", size: 10
          move_down 5
        end
        move_down 10
        stroke do
          stroke_color 'CCCCCC'
          line_width 0.2
          stroke_horizontal_rule
          move_down 15
        end
      end
    end
  end
end
