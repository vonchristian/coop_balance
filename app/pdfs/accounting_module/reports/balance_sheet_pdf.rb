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
        assets_table
        liabilities_table
        equities_table
      end

      private
      def price(number)
        @view_context.number_to_currency(number, :unit => "P ")
      end

      def heading
        bounding_box [300, 760], width: 50 do
          image "#{Rails.root}/app/assets/images/kccmc_logo.jpg", width: 40, height: 40
        end
        bounding_box [350, 760], width: 150 do
            text "KCCMC", style: :bold, size: 22
            text "Poblacion, Tinoc, Ifugao", size: 10
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
      def assets_table
        text "Assets", style: :bold
        table(assets_data, cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [300, 100]) do
          cells.borders =[]
          column(1).align = :right
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
        @assets_data ||= @assets.map{|a| [a.name, price(a.balance(to_date: @to_date))] } +
        [["TOTAL ASSETS", "#{price(AccountingModule::Asset.balance)}"]]
      end
       def liabilities_table
        text "Liabilities", style: :bold
        table(liabilities_data, cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [300, 100]) do
          cells.borders =[]
          column(1).align = :right
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
      def liabilities_data
        @liabilities_data ||= @liabilities.map{|a| [a.name, price(a.balance(to_date: @to_date))] } +
        [["TOTAL LIABILITIES", "#{price(AccountingModule::Liability.balance)}"]]

      end
     def equities_table
        text "Equity", style: :bold
        table(equities_data, cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [300, 100]) do
          cells.borders =[]
          column(1).align = :right
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
      def equities_data
        @equities_data ||= @equity.map{|a| [a.name, price(a.balance(to_date: @to_date))] } +
        [["TOTAL EQUITY", "#{price(AccountingModule::Equity.balance)}"]]

      end
    end
  end
end
