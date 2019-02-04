module AccountingModule
  module Reports
    class BalanceSheetPdf < Prawn::Document
      attr_reader :assets, :liabilities, :equity, :view_context, :to_date, :cooperative
      def initialize(args={})
        super(margin: 40, page_size: "A4", page_layout: :portrait)
        @from_date    = args[:from_date]
        @to_date      = args[:to_date]
        @assets       = args[:assets]
        @liabilities  = args[:liabilities]
        @equity       = args[:equity]
        @view_context = args[:view_context]
        @cooperative  = args[:cooperative]
        heading
        assets_table
        liabilities_table
        equities_table
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
            text "#{cooperative.abbreviated_name }", style: :bold, size: 20
            text "#{cooperative.name.try(:upcase)}", size: 8
            text "#{cooperative.address}", size: 8
        end
        bounding_box [0, 770], width: 400 do
          text "Balance Sheet", style: :bold, size: 12
          text "As of: #{to_date.strftime("%B %e, %Y")} ", style: :bold, size: 10
        end
        move_down 30
        stroke do
          stroke_color '24292E'
          line_width 1
          stroke_horizontal_rule
          move_down 5
        end
      end
      def assets_table
        text "Assets", style: :bold
        table(assets_data, cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [395, 120]) do
          cells.borders =[:bottom]
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
        @assets_data ||= assets.select{|r| !r.balance(to_date: to_date).round(2).zero?}.uniq.map{|a| [a.name, price(a.balance(to_date: to_date))] } +
        [["TOTAL ASSETS", "#{price(assets.balance(to_date: to_date))}"]]
      end
      def liabilities_table
        text "Liabilities", style: :bold
        table(liabilities_data, cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [395, 120]) do
          cells.borders =[:bottom]
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
        @liabilities_data ||= liabilities.select{|r| !r.balance(to_date: to_date).round(2).zero?}.uniq.map{|a| [a.name, price(a.balance(to_date: to_date))] } +
        [["TOTAL LIABILITIES", "#{price(liabilities.balance(to_date: to_date))}"]]

      end
     def equities_table
        text "Equity", style: :bold
        table(equities_data, cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [395, 120]) do
          cells.borders =[:bottom]
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
        table(total_equity_and_liabilities_data, cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [395, 120]) do
          cells.borders =[]
          column(1).align = :right
          row(-1).font_style = :bold
        end
      end
      def equities_data
        @equities_data ||= equity.select{|r| !r.balance(to_date: to_date).round(2).zero?}.uniq.map{|a| [a.name, price(a.balance(to_date: to_date))] } +
        [["TOTAL EQUITY", "#{price(equity.balance(to_date: to_date))}"]]
      end

      def total_equity_and_liabilities_data
        [["TOTAL EQUITY AND LIABILITIES", "#{price(cooperative.accounts.total_equity_and_liabilities(to_date: to_date))}"]]
      end
    end
  end
end
