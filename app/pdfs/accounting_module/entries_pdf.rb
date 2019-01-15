module AccountingModule
  class EntriesPdf < Prawn::Document
    attr_reader :entries, :employee, :view_context, :cooperative, :from_date, :to_date
    def initialize(args)
      super(margin: 30, page_size: "A4", page_layout: :portrait)
      @entries      = args[:entries]
      @employee     = args[:employee]
      @cooperative  = args[:cooperative]
      @view_context = args[:view_context]
      @from_date    = args[:from_date]
      @to_date      = args[:to_date]
      heading
      summary
      entries_table
      font Rails.root.join("app/assets/fonts/open_sans_regular.ttf")
    end

    private
    def display_commercial_document_for(entry)
      if entry.commercial_document.try(:member).present?
        entry.commercial_document.try(:member).try(:full_name)
      elsif entry.commercial_document.try(:borrower).present?
        entry.commercial_document.try(:borrower).try(:full_name)
      else
        entry.commercial_document.try(:name)
      end
    end

    def price(number)
      view_context.number_to_currency(number, :unit => "P ")
    end

    def heading
      bounding_box [300, 770], width: 50 do
        image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 50, height: 50
      end
      bounding_box [370, 770], width: 210 do
        text "#{cooperative.abbreviated_name}", style: :bold, size: 22
        text "#{cooperative.name}", size: 10
        move_down 10
      end

      bounding_box [0, 770], width: 400 do
        text "ENTRIES REPORT", style: :bold, size: 14
        move_down 5
        table([["Employee:", "#{employee.first_middle_and_last_name}"]], 
          cell_style: {padding: [0,0,1,0], inline_format: true, size: 10}, 
          column_widths: [50, 150]) do
          cells.borders = []
          column(1).font_style = :bold
        end
        table([["From:", "#{from_date.strftime("%B %e, %Y")}"]], 
          cell_style: {padding: [0,0,1,0], inline_format: true, size: 10}, 
          column_widths: [50, 150]) do
          cells.borders = []
          column(1).font_style = :bold
        end
        table([["To:", "#{to_date.strftime("%B %e, %Y")}"]], 
          cell_style: {padding: [0,0,1,0], inline_format: true, size: 10}, 
          column_widths: [50, 150]) do
          cells.borders = []
          column(1).font_style = :bold
        end
      end
      move_down 5
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.5
        stroke_horizontal_rule
        move_down 5
      end
    end

    def summary
      text "SUMMARY", size: 10, style: :bold
      move_down 5
      text "ENTRIES COUNT", size: 8
      text "#{entries.count}", size: 14
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.5
        stroke_horizontal_rule
        move_down 20
      end
    end

    def entries_table_header
      table([["DATE", "DESCRIPTION", "REF. NO.", "MEMBER/PAYEE", "ACCOUNT", "DEBIT", "CREDIT"]], 
        cell_style: { inline_format: true, size: 7, font: "Helvetica", padding: [4,1,4,1]}, 
        column_widths: [40, 135, 50, 70, 100, 70, 70]) do
          row(0).font_style= :bold
          row(0).background_color = 'DDDDDD'
          cells.borders = [:top, :bottom]
          column(5).align = :right
          column(6).align = :right
          column(2).align = :center
          column(1).align = :center
          column(4).align = :center
      end
    end

    def entries_table_footer
      table([["", "", "", "", "", price(entries.sum {|e| Money.new(e.debit_amounts.sum(:amount_cents)).amount}), price(entries.sum {|e| Money.new(e.credit_amounts.sum(:amount_cents)).amount})]], 
        cell_style: { inline_format: true, size: 8, font: "Helvetica", padding: [4,1,4,1]}, 
        column_widths: [40, 135, 50, 70, 100, 70, 70]) do
          row(0).font_style= :bold
          cells.borders = [:top, :bottom]
          column(5).align = :right
          column(6).align = :right
          column(2).align = :center
          column(1).align = :center
          column(4).align = :center
      end
    end

    def entries_table
      if !entries.any?
        move_down 10
        text "No entries data.", align: :center
      else
        entries_table_header

        entries.each do |entry|
          row_count = entry.amounts.count + 1
          debit_amounts_data = entry.debit_amounts.map{|a| [a.account.name, price(a.amount), ""] }
          credit_amounts_data = entry.credit_amounts.map{|a| [a.account.name, "", price(a.amount)] }
          sub_total = [[
            "SUB-TOTAL", 
            "#{price(entry.debit_amounts.sum{|a| a.amount})}", 
            "#{price(entry.credit_amounts.sum{|a| a.amount})}"
          ]]
          entries_data = [[
            {content: entry.entry_date.strftime("%m %e, %Y"), rowspan: row_count }, 
            {content: entry.description, rowspan: row_count, valign: :center}, 
            {content: "##{entry.reference_number}", rowspan: row_count},
            {content: display_commercial_document_for(entry).try(:upcase), rowspan: row_count, valign: :center},
            "", "", ""
          ]]

          table(entries_data + debit_amounts_data + credit_amounts_data, 
            cell_style: { inline_format: true, size: 8, padding: [1,1,3,1]}, 
            column_widths: [40, 135, 50, 70, 100, 70, 70]) do
            cells.borders = []
            row(0).height = 1
            column(2).align = :center
            column(6).align = :right
            column(5).align = :right
          end
          stroke do
            stroke_color '24292E'
            line_width 0.5
            stroke_horizontal_rule
            move_down 1
          end
          if entry.amounts.count > 2
            table(sub_total, position: :right,
              cell_style: { inline_format: true, size: 8, padding: [1,1,3,1]}, 
              column_widths: [100, 70, 70]) do
              cells.borders = []
              row(0).font_style= :bold
              column(1).align = :right
              column(2).align = :right
            end
            stroke do
              stroke_color '24292E'
              line_width 1
              stroke_horizontal_rule
              move_down 1
            end
          end
        end

        entries_table_footer
      end
    end
  end
end
