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

      def logo
        {image: "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", image_width: 50, image_height: 50}
      end

      def subtable_right
        sub_data ||= [[{content: "#{cooperative.abbreviated_name}", size: 22}]] + [[{content: "#{cooperative.name}", size: 10}]]
        make_table(sub_data, cell_style: {padding: [0,5,1,2]}) do
          columns(0).width = 180
          cells.borders = []
        end
      end

      def subtable_left
        sub_data ||= [[{content: "FINANCIAL CONDITION", size: 14, colspan: 2}]] + 
                      [[{content: "As of #{to_date.strftime("%b. %e, %Y")}", size: 10, colspan: 2}]]
        make_table(sub_data, cell_style: {padding: [0,5,1,2]}) do
          columns(0).width = 50
          columns(1).width = 150
          cells.borders = []
        end
      end

      def heading # 275, 50, 210
        bounding_box [bounds.left, bounds.top], :width  => 535 do
          table([[subtable_left, logo, subtable_right]], 
            cell_style: { inline_format: true, font: "Helvetica", padding: [0,5,0,0]}, 
            column_widths: [310, 50, 180]) do
              cells.borders = []
          end
        end
        stroke do
          move_down 3
          stroke_color '24292E'
          line_width 1
          stroke_horizontal_rule
          move_down 1
        end
        move_down 10
      end

      def asset_accounts
        text "ASSETS", size: 12, style: :bold
        move_down 5

        table(assets_data, header: false, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 385, 120]) do
          cells.borders = [:bottom]
          column(2).align = :right
        end
        move_down 2
        table(total_assets_data, header: true, cell_style: { inline_format: true, size: 11, font: "Helvetica"}, column_widths: [10, 385, 120]) do
          cells.borders = [:top, :bottom]
          column(2).align = :right
        end
      end

      def assets_data
        @assets_data ||= assets.select{|r| !r.balance(to_date: to_date).round(2).zero?}.uniq.map{ |a| ["", a.name, price(a.balance(to_date: to_date))] }
      end

      def total_assets_data
        [["", "<b>TOTAL ASSETS</b>", "<b>#{price(AccountingModule::Asset.active.balance(to_date: to_date))}</b>"]]
      end

      def liabilities_accounts
        move_down 30
        text "LIABILITIES AND MEMBERS' EQUITY", size: 10, style: :bold
        move_down 5
        text "LIABILITIES", size: 12, style: :bold
        move_down 5

        table(liabilities_data, header: false, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 385, 120]) do
          cells.borders = [:bottom]
          column(2).align = :right
        end
        move_down 2
        table(total_liabilities_data, header: true, cell_style: { inline_format: true, size: 11, font: "Helvetica"}, column_widths: [10, 385, 120]) do
          cells.borders = [:top, :bottom]
          column(2).align = :right
        end
      end

      def liabilities_data
        @liabilities_data ||= liabilities.select{|r| !r.balance(to_date: to_date).round(2).zero?}.uniq.map{ |a| ["", a.name, price(a.balance(to_date: to_date))] }
      end

      def total_liabilities_data
        [["", "<b>TOTAL LIABILITIES</b>", "<b>#{price(AccountingModule::Liability.active.balance(to_date: to_date))}</b>"]]
      end

      def equities_accounts
        move_down 10
        text "MEMBERS' EQUITY", size: 12, style: :bold

        table(equities_data, header: false, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 385, 120]) do
          cells.borders = [:bottom]
          column(2).align = :right
        end
        move_down 2
        table(total_equities_data, header: true, cell_style: { inline_format: true, size: 11, font: "Helvetica"}, column_widths: [10, 385, 120]) do
          cells.borders = [:top, :bottom]
          column(2).align = :right
        end
      end
      def equities_data
        @equities_data ||= equities.select{|r| !r.balance(to_date: to_date).round(2).zero?}.uniq.map{ |a| ["", a.name, price(a.balance(to_date: to_date))] }
      end
      def total_equities_data
        [["", "<b>TOTAL EQUITY</b>", "<b>#{price(AccountingModule::Equity.active.balance(to_date: to_date))}</b>"]]
      end

      def total_liabilities_and_equities(options={})
        move_down 10
        table(liabilities_and_equities_data(options), header: true, cell_style: { inline_format: true, size: 11, font: "Helvetica"}, column_widths: [395, 120]) do
          cells.borders = []
          column(1).align = :right
        end
      end
      def liabilities_and_equities_data(options={})
        [["<b>TOTAL LIABILITIES AND EQUITY</b>", "<b>#{price(liabilities_and_equities_total(options))}</b>"]]
      end

      def liabilities_and_equities_total(options={})
        AccountingModule::Liability.active.balance(to_date: to_date) +
        AccountingModule::Equity.active.balance(to_date: to_date)
      end
    end
  end
end
