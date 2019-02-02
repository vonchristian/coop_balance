module AccountingModule
  module Reports
    class FinancialConditionPdf < Prawn::Document
      attr_reader :from_date, :to_date, :assets, :liabilities, :equities, :employee, :view_context, :cooperative
      def initialize(args)
        super(margin: 40, page_size: "A4", page_layout: :portrait)
        @from_date    = args[:from_date]
        @to_date      = args[:to_date]
        @assets       = args[:assets]
        @liabilities  = args[:liabilities]
        @equities     = args[:equities]
        @employee     = args[:employee]
        @cooperative  = @employee.cooperative
        @view_context = args[:view_context]
        heading
        asset_accounts
        liabilities_accounts
        equities_accounts
        total_liabilities_and_equities
      end

      private
      def price(number)
        view_context.number_to_currency(number, :unit => "P ")
      end

      def heading
        bounding_box [300, 760], width: 50 do
          image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 40, height: 40
        end
        bounding_box [350, 760], width: 150 do
            text "#{cooperative.abbreviated_name.upcase}", style: :bold, size: 22
            text "#{cooperative.address}", size: 10
        end
        bounding_box [0, 760], width: 400 do
          text "Statement of Financial Condition", style: :bold, size: 14
          move_down 5
          text "#{to_date.strftime("%B %e, %Y")} ", size: 10
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

      def asset_accounts
        text "ASSETS", size: 12, style: :bold
        move_down 5

        table(assets_data, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 384, 120]) do
          cells.borders = [:bottom]
          column(2).align = :right
        end

        stroke do
          stroke_color 'CCCCCC'
          line_width 0.2
          stroke_horizontal_rule
          move_down 1
        end
        stroke do
          stroke_color 'CCCCCC'
          line_width 0.2
          stroke_horizontal_rule
          move_down 10
        end

        table(total_assets_data, header: true, cell_style: { inline_format: true, size: 11, font: "Helvetica"}, column_widths: [120, 275, 120]) do
          cells.borders = []
          column(2).align = :right
        end
      end

      def assets_data
        @assets_data ||= assets.uniq.map{ |a| ["", a.name, price(a.balance(to_date: to_date))] }
      end

      def total_assets_data
        [["<b>TOTAL ASSETS</b>", "", "<b>#{price(AccountingModule::Asset.balance(to_date: to_date))}</b>"]]
      end

      def liabilities_accounts
        move_down 10
        text "LIABILITIES AND MEMBERS' EQUITY", size: 11, style: :bold
        move_down 5
        text "LIABILITIES", size: 12, style: :bold
        move_down 5

        table(liabilities_data, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 384, 120]) do
          cells.borders = [:bottom]
          column(2).align = :right
        end

        stroke do
          stroke_color 'CCCCCC'
          line_width 0.2
          stroke_horizontal_rule
          move_down 10
        end

        table(total_liabilities_data, header: true, cell_style: { inline_format: true, size: 11, font: "Helvetica"}, column_widths: [120, 275, 120]) do
          cells.borders = []
          column(2).align = :right
        end
      end

      def liabilities_data
        @liabilities_data ||= liabilities.uniq.map{ |a| ["", a.name, price(a.balance(to_date: to_date))] }
      end

      def total_liabilities_data
        [["<b>TOTAL LIABILITIES</b>", "", "<b>#{price(AccountingModule::Liability.balance(to_date: to_date))}</b>"]]
      end

      def equities_accounts
        move_down 10
        text "MEMBERS' EQUITY", size: 12, style: :bold

        table(equities_data, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 384, 120]) do
          cells.borders = [:bottom]
          column(2).align = :right
        end

        stroke do
          stroke_color 'CCCCCC'
          line_width 0.2
          stroke_horizontal_rule
          move_down 10
        end

        table(total_equities_data, header: true, cell_style: { inline_format: true, size: 11, font: "Helvetica"}, column_widths: [120, 275, 120]) do
          cells.borders = []
          column(2).align = :right
        end
      end
      def equities_data
        @equities_data ||= equities.uniq.map{ |a| ["", a.name, price(a.balance(to_date: to_date))] }
      end
      def total_equities_data
        [["<b>TOTAL EQUITY</b>", "", "<b>#{price(AccountingModule::Equity.balance(to_date: to_date))}</b>"]]
      end

      def total_liabilities_and_equities(options={})
        move_down 10
        table(liabilities_and_equities_data(options), header: true, cell_style: { inline_format: true, size: 11, font: "Helvetica"}, column_widths: [220, 174, 120]) do
          cells.borders = []
          column(2).align = :right
        end
      end
      def liabilities_and_equities_data(options={})
        [["<b>TOTAL LIABILITIES AND EQUITY</b>", "", "<b>#{price(liabilities_and_equities_total(options))}</b>"]]
      end

      def liabilities_and_equities_total(options={})
        AccountingModule::Liability.balance(to_date: to_date) +
        AccountingModule::Equity.balance(to_date: to_date)
      end
    end
  end
end
