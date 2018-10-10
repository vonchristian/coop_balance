module CooperativeServices
  class BalanceSheetPdf < Prawn::Document
    attr_reader :accounts, :from_date, :to_date, :view_context, :cooperative_service, :cooperative
    def initialize(args={})
      super(margin: 40, page_size: "A4", page_layout: :portrait)
      @accounts            = args[:accounts]
      @cooperative_service = args[:cooperative_service]
      @cooperative         = @cooperative_service.cooperative
      @from_date           = args[:from_date]
      @to_date             = args[:to_date]
      @view_context        = args[:view_context]
      heading
      accounts_details
    end

    private
    def price(number)
      view_context.number_to_currency(number, :unit => "P ")
    end

    def heading
      bounding_box [300, 770], width: 50 do
        image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 50, height: 50
      end
      bounding_box [360, 770], width: 170 do
          text "#{cooperative.abbreviated_name }", style: :bold, size: 20
          text "#{cooperative.name.try(:upcase)}", size: 8
          text "#{cooperative.address}", size: 8
      end
      bounding_box [0, 770], width: 300 do
        text "BALANCE SHEET", style: :bold, size: 12
        text "#{cooperative_service.title}", size: 11, style: :bold
        text "As of: #{to_date.strftime("%B %e, %Y")}", size: 10
      end
      move_down 20
      stroke do
        move_down 5
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
    end

    def accounts_details
      text "Asssets", style: :bold
      table(assets_data, cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [300, 100]) do
        cells.borders =[]
        column(1).align = :right
        row(-1).font_style = :bold
      end
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
      text "Liabilities", style: :bold
      table(liabilities_data, cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [300, 100]) do
        cells.borders =[]
        column(1).align = :right
        row(-1).font_style = :bold
      end
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
      text "Equity", style: :bold
      table(equity_data, cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [300, 100]) do
        cells.borders =[]
        column(1).align = :right
        row(-1).font_style = :bold
      end
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
      table(liabilities_and_equities_data, cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [300, 100]) do
        cells.borders =[]
        column(1).align = :right
        row(-1).font_style = :bold
      end
    end

    def assets_data
      [["", ""]] +
      @assets_data ||= accounts.assets.map{|a| [a.name, price(a.balance(cooperative_service_id: cooperative_service.id, from_date: from_date, to_date: to_date))] } +
      [["TOTAL ASSETS", "#{price(cooperative_service.accounts.assets.balance(cooperative_service_id: cooperative_service.id, from_date: from_date, to_date: to_date))}"]]
    end
    def liabilities_data
      [["", ""]] +
      @liabilities_data ||= accounts.liabilities.map{|a| [a.name, price(a.balance(cooperative_service_id: cooperative_service.id, from_date: from_date, to_date: to_date))] } +
      [["TOTAL LIABILITIES", "#{price(cooperative_service.accounts.liabilities.balance(cooperative_service_id: cooperative_service.id, from_date: from_date, to_date: to_date))}"]]
    end
    def equity_data
      [["", ""]] +
      @equity_data ||= accounts.equities.map{|a| [a.name, price(a.balance(cooperative_service_id: cooperative_service.id, from_date: from_date, to_date: to_date))] } +
      [["TOTAL EQUITY", "#{price(cooperative_service.accounts.equities.balance(cooperative_service_id: cooperative_service.id, from_date: from_date, to_date: to_date))}"]]
    end
    def liabilities_and_equities_data
      [["TOTAL LIABILITIES AND EQUITY", "#{price(cooperative_service.accounts.total_equity_and_liabilities(cooperative_service_id: cooperative_service.id, from_date: from_date, to_date: to_date))}"]]

    end
  end
end
