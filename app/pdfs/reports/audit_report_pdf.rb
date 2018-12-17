module Reports
  class AuditReportPdf < Prawn::Document
    def initialize(entries, employee, from_date, to_date, title, view_context)
      super(margin: 20, page_size: "A4", page_layout: :portrait)

      @entries = entries
      @employee = employee
      @from_date = from_date
      @to_date = to_date
      @title = title
      @view_context = view_context
      heading
      sundries_summary
      entries_table
    end
    private
    def price(number)
      @view_context.number_to_currency(number, :unit => "P ")
    end
    def display_commercial_document_for(entry)
      if entry.commercial_document.try(:member).present?
        entry.commercial_document.try(:member).try(:full_name)
      elsif entry.commercial_document.try(:depositor).present?
        entry.commercial_document.try(:depositor).try(:full_name)
      elsif entry.commercial_document.try(:borrower).present?
        entry.commercial_document.try(:borrower).try(:full_name)
      else
        entry.commercial_document.name
      end
    end

    def heading
      bounding_box [300, 800], width: 50 do
        image "#{Rails.root}/app/assets/images/ipsmpc_logo.jpg", width: 50, height: 50
      end
      bounding_box [370, 800], width: 200 do
          text "#{@employee.cooperative_abbreviated_name}", style: :bold, size: 24
          text "#{@employee.cooperative_name}", size: 10
      end
      bounding_box [0, 800], width: 400 do
        text "#{@title}", style: :bold, size: 12
        move_down 5
        table([["Employee:", "#{@employee.first_and_last_name}"]], 
          cell_style: {padding: [0,0,1,0], inline_format: true, size: 10}, 
          column_widths: [50, 150]) do
          cells.borders = []
        end
        table([["From:", "#{@from_date.strftime("%B %e, %Y")}"]], 
          cell_style: {padding: [0,0,1,0], inline_format: true, size: 10}, 
          column_widths: [50, 150]) do
          cells.borders = []
        end
        table([["To:", "#{@to_date.strftime("%B %e, %Y")}"]], 
          cell_style: {padding: [0,0,1,0], inline_format: true, size: 10}, 
          column_widths: [50, 150]) do
          cells.borders = []
        end
      end
      move_down 15
      stroke do
        stroke_color '24292E'
        line_width 1
        stroke_horizontal_rule
        move_down 20
      end
    end

    def sundries_summary
      text "SUMMARY OF ACCOUNTS", style: :bold, size: 10
      table(sundries_summary_data, cell_style: { inline_format: true, size: 10, font: "Helvetica", padding: [1,5,2,0]}, column_widths: [20, 60, 220, 120, 120]) do
        cells.borders = []
        row(0).font_style = :bold
        column(1).align = :right
        column(3).align = :right
        column(4).align = :right
      end
      move_down 10
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
    end

    def sundries_summary_data
      [["", "Code", "Account Title ", "Debits", "Credits"]] +
      @sundries_summary ||= AccountingModule::Account.updated_at(from_date: @from_date.beginning_of_day, to_date: @to_date.end_of_day).updated_by(@employee).uniq.map{ |a| ["", a.code, a.name, price(a.debits_balance(from_date: @from_date.beginning_of_day, to_date: @to_date.end_of_day)), price(a.credits_balance(from_date: @from_date.beginning_of_day, to_date: @to_date.end_of_day))]} +
      [["", "", "<b>TOTAL</b>",
        "<b>#{price(AccountingModule::Account.updated_at(from_date: @from_date.beginning_of_day, to_date: @to_date.end_of_day).uniq.map{|a| a.debits_balance(from_date: @from_date.beginning_of_day, to_date: @to_date.end_of_day)}.sum )}</b>",
        "<b>#{price(AccountingModule::Account.updated_at(from_date: @from_date.beginning_of_day, to_date: @to_date.end_of_day).uniq.map{|a| a.credits_balance(from_date: @from_date.beginning_of_day, to_date: @to_date.end_of_day)}.sum )}</b>"]]

    end

    def entries_table
      if !@entries.any?
        move_down 10
        text "No entries data.", align: :center
      else
        
        text "TRANSACTION DETAILS:", size: 10, style: :bold
        move_down 5
        table([["DATE", "DESCRIPTION", "REF. NO.", "PARTICULAR/PAYEE", "EMPLOYEE", "", "", ""]], 
          cell_style: { inline_format: true, size: 6, font: "Helvetica"}, 
          column_widths: [40, 100, 50, 70, 50, 100, 70, 70]) do
          cells.borders = [:top]
          row(0).font_style= :bold
          row(0).background_color = 'DDDDDD'
          column(-1).align = :right
        end
        @entries.uniq.each do |entry|
          table([["#{entry.entry_date.strftime("%b %e, %Y")}", 
            "#{entry.description.truncate(80)}", 
            "#{entry.reference_number}", 
            "#{display_commercial_document_for(entry).try(:upcase)}", 
            "#{entry.recorder.try(:first_and_last_name).try(:upcase)}",
            "ACCOUNT", "DEBIT", "CREDIT"]], 
            cell_style: { size: 8, padding: [5,5,4,0]}, 
            column_widths: [40, 100, 50, 70, 50, 100, 70, 70]) do
              cells.borders = [:top]
              column(5).align = :center
              column(6).align = :right
              column(7).align = :right
              column(5).font_style = :bold
              column(6).font_style = :bold
              column(7).font_style = :bold
              style column(5), :size => 7
              style column(6), :size => 7
              style column(7), :size => 7
          end
          amounts(entry)
        end
        table_footer
      end
    end

    def amounts(entry)
      table(entry.debit_amounts.map{|a| ["", "", "", "", "", a.account.name, price(a.amount), ""] }, 
        column_widths: [40, 100, 50, 70, 50, 100, 70, 70], 
        cell_style: { inline_format: true, size: 8, padding: [1,1,3,1]}) do
          cells.borders = []
          column(6).align = :right
      end

      table(entry.credit_amounts.map{|a| ["", "", "", "", "", a.account.name, "", price(a.amount)] }, 
        column_widths: [40, 100, 50, 70, 50, 100, 70, 70], 
        cell_style: {inline_format: true, padding: [1,1,3,1], size: 8} ) do
          cells.borders = []
          column(7).align = :right
      end

      stroke do
        stroke_color '24292E'
        line_width 1
        stroke_horizontal_rule
        move_down 5
      end

      table([["", "", "", "", "", "SUB-TOTAL", 
        "#{price(entry.debit_amounts.sum{|a| a.amount})}", 
        "#{price(entry.credit_amounts.sum{|a| a.amount})}"]], 
        cell_style: { inline_format: true, size: 8, font: "Helvetica", padding: [1,1,4,1]}, 
        column_widths: [40, 100, 50, 70, 50, 100, 70, 70]) do
          row(0).font_style= :bold
          cells.borders = []
          column(5).align = :center
          column(6).align = :right
          column(7).align = :right
      end
    end

    def table_footer
      total_debit_amounts = @entries.sum {|e| e.debit_amounts.sum {|d| d.amount}}
      total_credit_amounts = @entries.sum {|e| e.credit_amounts.sum {|c| c.amount}}
      table([["", "", "", "", "", "TOTAL", price(total_debit_amounts), price(total_credit_amounts)]], 
        cell_style: { inline_format: true, size: 8, font: "Helvetica", padding: [4,1,4,1]}, 
        column_widths: [40, 100, 50, 70, 50, 100, 70, 70]) do
          row(0).font_style= :bold
          cells.borders = [:top]
          column(7).align = :right
          column(6).align = :right
      end
    end
  end
end
