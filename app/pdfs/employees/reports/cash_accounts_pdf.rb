module Employees
  module Reports
    class CashAccountsPdf < Prawn::Document
      attr_reader :entries, :employee, :from_date, :to_date, :view_context, :cooperative, :accounts, :title
      def initialize(args)
        super(margin: 30, page_size: "A4", page_layout: :portrait)
        @entries      = args[:entries]
        @employee     = args[:employee]
        @cooperative  = @employee.cooperative
        @accounts     = @employee.cash_accounts
        @from_date    = args[:from_date]
        @to_date      = args[:to_date]
        @title        = args[:title]
        @view_context = args[:view_context]
        heading
        accounts_table
        entries_table
      end
      private
      def price(number)
        view_context.number_to_currency(number, :unit => "P ")
      end
      def display_commercial_document_for(entry)
        if entry.commercial_document.try(:member).present?
          entry.commercial_document.try(:member).try(:full_name)
        elsif entry.commercial_document.try(:borrower).present?
          entry.commercial_document.try(:borrower).try(:full_name)
        else
          entry.commercial_document.try(:name)
        end
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
          text "#{title}", style: :bold, size: 12
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
        "#{price(accounts.balance(to_date: to_date.yesterday.end_of_day))}",
        "#{price(accounts.debits_balance(to_date: to_date))}",
        "#{price(accounts.credits_balance(to_date: to_date))}",
        "#{price(accounts.balance(to_date: to_date))}",
        ""]], cell_style: { inline_format: true, size: 8, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [45, 150, 80, 80, 80, 80]) do
        cells.borders = []
        column(2).align = :right
        column(3).align = :right
        column(4).align = :right
        column(5).align = :right
        row(-1).font_style = :bold
      end
      move_down 10
    end
    def accounts_data
      [["CODE", "ACCOUNT TITLE", "BEGINNING BALANCE", "DEBITS", "CREDITS", "ENDING BALANCE"]] +
      @accounts_data ||= accounts.map{|a| [a.code, a.name, price(a.balance(to_date: to_date.yesterday.end_of_day)), price(a.debits_balance(to_date: to_date)), price(a.credits_balance(to_date: to_date)), price(a.balance(to_date: @to_date))] }
    end
      def entries_table
        if !@entries.any?
          move_down 10
          text "No entries data.", align: :center
        else
          table([["DATE", "DESCRIPTION", "REFERENCE #", "MEMBER/PAYEE",  "ACCOUNT", "AMOUNT"]], cell_style: { inline_format: true, size: 6, font: "Helvetica"}, column_widths: [50, 150, 50, 100,  100, 80]) do
            row(0).font_style= :bold
            row(0).background_color = 'DDDDDD'
          end
          entries.each do |entry|
            table([["#{entry.entry_date.strftime("%b %e, %Y")}", "#{entry.description}", "#{entry.reference_number}",  "#{display_commercial_document_for(entry)}",]], cell_style: { size: 9, padding: [5,5,4,0]}, column_widths: [50, 150, 50,  100,  100, 80]) do
              cells.borders = []
            end
            table([["", "", "", "", "", "<b>DEBIT</b>"]]+
              entry.debit_amounts.map{|a| ["", "", "",  "", "", a.account.name,  price(a.amount)] }, column_widths: [50, 100, 50, 100, 50, 100, 80], cell_style: { inline_format: true, size: 8, padding: [0,0,0,0]}) do
              cells.borders = []
              column(-1).align = :right
            end
            table([["",  "", "","", "", "<b>CREDIT</b>"]] + entry.credit_amounts.map{|a| ["", "", "",  "", "",  a.account.name, price(a.amount)] }, column_widths: [50, 100, 50, 100, 50, 100, 80], cell_style: {inline_format: true, padding: [0,0,2,0], size: 8} ) do
              cells.borders = []
              column(-1).align = :right
            end
            stroke do
              stroke_color 'CCCCCC'
              line_width 0.2
              stroke_horizontal_rule
            end
          end
        end
      end
    end
  end
end

