
module CooperativeServices
  class BalanceSheetPdf < Prawn::Document
    attr_reader :cooperative_service, :accounts, :view_context, :to_date, :cooperative
    def initialize(args)
      super(margin: 40, page_size: "A4", page_layout: :portrait)
      @cooperative_service = args[:cooperative_service]
      @cooperative         = @cooperative_service.cooperative
      @accounts            = args[:accounts]
      @view_context        = args[:view_context]
      @to_date             = args[:to_date]
      heading
      accounts_details
    end

    private
    def price(number)
      view_context.number_to_currency(number, :unit => "P ")
    end

    def heading
      bounding_box [350, 760], width: 200 do
          text "#{cooperative.abbreviated_name.try(:upcase)}", style: :bold, size: 22
          text "#{cooperative.name}", size: 10
          move_down 2
          text "#{cooperative.address}", size: 10
      end
      bounding_box [0, 760], width: 400 do
        text "Balance Sheet", style: :bold, size: 14
        move_down 5
        text "#{cooperative_service.title}", size: 10, style: :bold
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

    def accounts_details
      text "ASSETS", style: :bold, size: 10
      table(assets_data, cell_style: { inline_format: true, size: 8, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [20, 150, 100]) do
        cells.borders =[]
        row(-1).font_style = :bold
        column(2).align = :right
      end
      stroke do
        move_down 5
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
      text "EQUITY", style: :bold, size: 10
      table(equity_data, cell_style: { inline_format: true, size: 8, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [20, 150, 100]) do
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
      text "LIABILITIES", style: :bold, size: 10
      table(liabilities_data, cell_style: { inline_format: true, size: 8, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [20, 150, 100]) do
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
      text "TOTAL EQUITY AND LIABILITIES", style: :bold, size: 10

      table(equity_and_liabilities_data, cell_style: { inline_format: true, size: 8, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [20, 150, 100]) do
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
      @assets_data ||= accounts.assets.map{|a| ["", a.name, price(a.balance(to_date: to_date, cooperative_service_id: cooperative_service.id))] } +
      [["", "TOTAL ASSETS", "#{price(cooperative_service.accounts.assets.balance(cooperative_service_id: cooperative_service.id, to_date: to_date))}"]]
    end

    def equity_data
      @equity_data ||= accounts.equities.map{|a| ["", a.name, price(a.balance(to_date: to_date, cooperative_service_id: cooperative_service.id))] } +
      [["", "TOTAL EQUITY", "#{price(cooperative_service.accounts.equities.balance(cooperative_service_id: cooperative_service.id, to_date: to_date))}"]]
    end

    def liabilities_data
      @liabilities_data ||= accounts.liabilities.map{|a| ["", a.name, price(a.balance(to_date: to_date, cooperative_service_id: cooperative_service.id))] } +
      [["", "TOTAL LIABILITIES", "#{price(cooperative_service.accounts.liabilities.balance(cooperative_service_id: cooperative_service.id, to_date: to_date))}"]]
    end

    def equity_and_liabilities_data
      [["", "TOTAL EQUITY AND LIABILITIES", "#{price(cooperative_service.accounts.total_equity_and_liabilities(cooperative_service_id: cooperative_service.id, to_date: to_date))}"]]
    end
  end
end
