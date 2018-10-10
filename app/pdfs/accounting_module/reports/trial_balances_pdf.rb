module AccountingModule
  module Reports
    class TrialBalancesPdf < Prawn::Document
      attr_reader :accounts, :to_date, :view_context, :cooperative
      def initialize(args)
        super(margin: 40, page_size: "A4", page_layout: :portrait)
        @accounts     = args[:accounts]
        @to_date      = args[:to_date]
        @view_context = args[:view_context]
        @cooperative  = args[:cooperative]
        heading
        accounts_table
      end

      private
      def price(number)
        @view_context.number_to_currency(number, :unit => "P ")
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
          text "TRIAL BALANCE", style: :bold, size: 12
          text "#{to_date.strftime("%B %e, %Y")}", size: 10
        end
        move_down 30
        stroke do
          stroke_color '24292E'
          line_width 1
          stroke_horizontal_rule
          move_down 5
        end
      end

      def accounts_table
      table(accounts_data, cell_style: { inline_format: true, size: 8, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [45, 150, 80, 80, 80, 80]) do
        cells.borders = []
        row(0).font_style= :bold
        # row(0).background_color = 'DDDDDD'
        column(2).align = :right
        column(3).align = :right
        column(4).align = :right
        column(5).align = :right
      end
      move_down 4
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 4
      end
      table([["TOTAL", "",
        "#{price(accounts.balance(from_date: to_date, to_date: to_date))}"]], cell_style: { inline_format: true, size: 8, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [45, 150, 80, 80, 80, 80]) do
        cells.borders = []
        column(2).align = :right
        column(3).align = :right
        column(4).align = :right
        column(5).align = :right
        row(-1).font_style = :bold
      end
    end
    def accounts_data
      [["CODE", "ACCOUNT TITLE", "BEGINNING BALANCE", "DEBITS", "CREDITS", "ENDING BALANCE"]] +
      @accounts_data ||= accounts.map{|a| [a.code, a.name, price(a.balance(to_date: to_date)), price(a.debits_balance(to_date: to_date)), price(a.credits_balance(to_date: to_date)), price(a.balance(to_date: @to_date))] }
    end
    end
  end
end
