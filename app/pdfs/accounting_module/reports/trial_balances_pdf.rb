module AccountingModule
  module Reports
    class TrialBalancesPdf < Prawn::Document
      def initialize(accounts, to_date, view_context)
        super(margin: 40, page_size: "A4", page_layout: :portrait)
        @accounts = accounts
        @to_date = to_date
        @view_context = view_context
        heading
        accounts_table
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
          text "Trial Balance", style: :bold, size: 14
          move_down 5
          text "#{@to_date.to_date.strftime("%B %e, %Y")}", size: 10
          move_down 5
          text "Date Generated: #{Time.zone.now.strftime("%B %e, %Y %H:%M %p")}", size: 9
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

      def accounts_table
      table(accounts_data, cell_style: { inline_format: true, size: 9, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [45, 150, 80, 80, 80, 80]) do
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
      table([["TOTAL", "", "#{price(AccountingModule::Account.updated_at(from_date: @to_date, to_date: @to_date).distinct.map{|a| a.balance(to_date: @to_date.yesterday.end_of_day)}.sum) }", "#{price(AccountingModule::Account.updated_at(from_date: @to_date, to_date: @to_date).distinct.map{|a| a.debits_balance(to_date: @to_date)}.sum) }", "#{price(AccountingModule::Account.updated_at(from_date: @to_date, to_date: @to_date).distinct.map{|a| a.credits_balance(to_date: @to_date)}.sum) }", "#{price(AccountingModule::Account.updated_at(from_date: @to_date, to_date: @to_date).distinct.map{|a| a.balance(to_date: @to_date)}.sum) }"]], cell_style: { inline_format: true, size: 10, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [45, 150, 80, 80, 80, 80]) do
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
      @accounts_data ||= AccountingModule::Account.updated_at(from_date: @to_date, to_date: @to_date).uniq.map{|a| [a.code, a.name, price(a.balance(to_date: @to_date.yesterday.end_of_day)), price(a.debits_balance(to_date: @to_date)), price(a.credits_balance(to_date: @to_date)), price(a.balance(to_date: @to_date))] }
    end
    end
  end
end
