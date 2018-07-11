module AccountingModule
  module Reports
    class BalanceSheetPdf2 < Prawn::Document
      attr_reader :cooperative_service, :asset_accounts, :view_context, :to_date
      def initialize(assets:, cooperative_service:, view_context:, to_date:)
        super(margin: 40, page_size: "A4", page_layout: :portrait)
          @cooperative_service = cooperative_service
          @asset_accounts      = assets
          @view_context        = view_context
          @to_date             = to_date
        heading
        assets_details
      end
      private
      def price(number)
        @view_context.number_to_currency(number, :unit => "P ")
      end

      def heading
        bounding_box [350, 760], width: 150 do
            text "KCCMC", style: :bold, size: 22
            text "Poblacion, Tinoc, Ifugao", size: 10
        end
        bounding_box [0, 760], width: 400 do
          text "Balance Sheet", style: :bold, size: 14
          move_down 5
          text "#{cooperative_service.title.try(:upcase)}", size: 10, style: :bold
          move_down 6
          text "As of #{to_date.strftime("%B %e, %Y")}", size: 10
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
      def assets_details
        text "ASSETS", style: :bold, size: 10
        table(assets_data, cell_style: { inline_format: true, size: 8, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [20, 300, 100]) do
          cells.borders =[]
          row(-1).font_style = :bold
        end
        stroke do
          move_down 5
          stroke_color 'CCCCCC'
          line_width 0.2
          stroke_horizontal_rule
          move_down 15
        end
      end
      def assets_data
        @assets_data ||= asset_accounts.map{|a| ["", a.name, price(a.balance(to_date: @to_date))] } +
        [["", "TOTAL ASSETS", "#{price(AccountingModule::Asset.balance(cooperative_service: cooperative_service))}"]]
      end
    end
  end
end
