module AccountingModule
  module Accounts
    class EntriesReportPdf < Prawn::Document
      def initialize(entries, account, employee, from_date, to_date, view_context)
        super(margin: 40, page_size: "A4", page_layout: :portrait)
        @entries      = entries
        @account      = account
        @employee     = employee
        @from_date    = from_date
        @to_date      = to_date
        @view_context = view_context
        heading
        entries_table
      end

      private
      def price(number)
        @view_context.number_to_currency(number, :unit => "P ")
      end

      def heading
    bounding_box [300, 780], width: 50 do
      # image "#{@employee.cooperative.logo.path(:medium)}", width: 50, height: 50
    end
    bounding_box [370, 780], width: 150 do
        text "#{@employee.cooperative_abbreviated_name}", style: :bold, size: 24
        text "#{@employee.cooperative_name}", size: 10
    end
    bounding_box [0, 780], width: 400 do
      text "Account Entries Report", style: :bold, size: 14
      move_down 3
      text "#{Time.zone.now.strftime("%B %e, %Y")}", size: 10
      move_down 3

      text "Account: #{@account.name}", size: 10
    end
    move_down 15
    stroke do
      stroke_color '24292E'
      line_width 1
      stroke_horizontal_rule
      move_down 20
    end
  end
      def entries_table
      if !@entries.any?
        move_down 10
        text "No entries data.", align: :center
      else
        move_down 10
        stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
        end
        table(table_data, header: true, cell_style: { size: 8, font: "Helvetica"}, column_widths: [80, 150, 80]) do
          row(0).font_style = :bold
          row(0).background_color = 'DDDDDD'
          column(0).align = :right
          column(3).align = :right
          column(4).align = :right
        end
      end
    end

    def table_data
      move_down 5
      [["DATE", "DESCRIPTION", "REFERENCE NUMBER", "AMOUNT", "CUSTOMER", "EMPLOYEE"]] +
      @table_data ||= @entries.map { |e| [ e.entry_date.strftime("%B %e, %Y"), e.description, e.reference_number, price(e.debit_amounts.where(account: @account).sum(&:amount)), e.commercial_document.try(:name), e.recorder.try(:first_and_last_name)]}
    end
    end
  end
end
