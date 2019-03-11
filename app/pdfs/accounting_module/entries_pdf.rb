module AccountingModule
  class EntriesPdf < Prawn::Document
    attr_reader :entries, :employee, :title, :view_context, :cooperative, :cooperative_service, :from_date, :to_date, :organization
    def initialize(args)
      super(margin: 30, page_size: "A4", page_layout: :portrait)
      @entries      = args[:entries]
      @employee     = args[:employee]
      @cooperative  = args[:cooperative]
      @cooperative_service = args[:cooperative_service] if args[:cooperative_service].present?
      @view_context = args[:view_context]
      @from_date    = args[:from_date]
      @to_date      = args[:to_date]
      @organization = args[:organization]
      @title        = args[:title]

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

    def logo
      {image: "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", image_width: 50, image_height: 50}
    end

    def subtable_right
      sub_data ||= [[{content: "#{cooperative.abbreviated_name}", size: 22}]] + [[{content: "#{cooperative.name}", size: 10}]]
      make_table(sub_data, cell_style: {padding: [0,5,1,2]}) do
        columns(0).width = 140
        cells.borders = []
      end
    end

    def subtable_left
      sub_data ||= [[{content: "#{title}", size: 14, colspan: 2}]] + 
                    [[{content: "#{cooperative_service.try(:title)}", size: 12, colspan: 2}]] +
                    [[{content: "From:", size: 10}, {content: "#{from_date.strftime("%b. %e, %Y")}", size: 10}]] +
                    [[{content: "To:", size: 10}, {content: "#{to_date.strftime("%b. %e, %Y")}", size: 10}]]
      make_table(sub_data, cell_style: {padding: [0,5,1,2]}) do
        columns(0).width = 80
        columns(1).width = 230
        cells.borders = []
      end
    end

    def heading # 275, 50, 210
      bounding_box [bounds.left, bounds.top], :width  => 535 do
        table([[subtable_left, logo, subtable_right]], 
          cell_style: { inline_format: true, font: "Helvetica", padding: [0,5,0,0]}, 
          column_widths: [340, 50, 140]) do
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

    def summary
      text "SUMMARY", size: 10, style: :bold
      move_down 5
      text "ENTRIES COUNT", size: 8
      text "#{entries.count}", size: 14
      move_down 5
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
      table([["", "", "", "", "TOTAL", price(entries.sum {|e| Money.new(e.debit_amounts.sum(:amount_cents)).amount}), price(entries.sum {|e| Money.new(e.credit_amounts.sum(:amount_cents)).amount})]], 
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

        entries.sort_by(&:ascending_order).each do |entry|
          row_count = entry.amounts.count + 1
          debit_amounts_data = entry.debit_amounts.map{|a| [a.account.name, price(a.amount), ""] }
          credit_amounts_data = entry.credit_amounts.map{|a| [a.account.name, "", price(a.amount)] }
          sub_total = [[
            "SUB-TOTAL", 
            "#{price(entry.debit_amounts.sum{|a| a.amount})}", 
            "#{price(entry.credit_amounts.sum{|a| a.amount})}"
          ]]
          entries_data = [[
            {content: entry.entry_date.strftime("%D"), rowspan: row_count }, 
            {content: entry.description, rowspan: row_count}, 
            {content: "##{entry.reference_number}", rowspan: row_count},
            {content: display_commercial_document_for(entry).try(:upcase), rowspan: row_count},
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
