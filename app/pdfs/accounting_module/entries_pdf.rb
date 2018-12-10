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
      bounding_box [280, 790], width: 50 do
        image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 55, height: 55
      end
      bounding_box [340, 790], width: 200 do
          text "#{cooperative.abbreviated_name }", style: :bold, size: 20
          text "#{cooperative.name.try(:upcase)}", size: 8
          text "#{cooperative.address}", size: 8
      end
      bounding_box [0, 790], width: 400 do
        text "ENTRIES REPORT", style: :bold, size: 12
        text "Date Covered: #{from_date.strftime("%b. %e, %Y")} - #{to_date.strftime("%b. %e, %Y")}", size: 10
        move_down 2
      end
      move_down 35
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.5
        stroke_horizontal_rule
        move_down 20
      end
    end
    def summary
      text "SUMMARY", size: 10, style: :bold
      move_down 5
      text "ENTRIES COUNT", size: 8
      text "#{entries.count}", size: 14
      move_down 5
      text "#{employee.full_name}"
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.5
        stroke_horizontal_rule
        move_down 20
      end
    end
    def entries_table
      if !entries.any?
        move_down 10
        text "No entries data.", align: :center
      else
        table([["DATE", "PARTICULARS", "REFERENCE NUMBER", "MEMBER / PAYEE",  "ACCOUNT", "AMOUNT"]], cell_style: { inline_format: true, size: 6, font: "Helvetica"}, column_widths: [50, 150, 50, 100,  100, 80]) do
          row(0).font_style= :bold
          row(0).background_color = 'DDDDDD'
        end
        entries.order(entry_date: :desc).each do |entry|
          table([["#{entry.entry_date.strftime("%B %e, %Y")}", "#{entry.description} #{entry.cancellation_text} - #{entry.cancellation_description}", "#{entry.reference_number}",  "#{display_commercial_document_for(entry).try(:upcase)}",]], cell_style: { size: 9, padding: [5,5,4,0]}, column_widths: [50, 150, 50,  100,  100, 80]) do
            cells.borders = []
          end
          table([["", "", "", "", "", "<b>DEBIT</b>"]]+
            entry.debit_amounts.map{|a| ["", "", "",  "", "", a.account.name,  price(a.amount)] }, column_widths: [50, 100, 50, 100, 50, 100, 80], cell_style: { inline_format: true, size: 8, padding: [0,0,0,0]}) do
            cells.borders = []
            column(-1).align = :right
          end
          move_down 5
          table([["",  "", "","", "", "<b>CREDIT</b>"]] + entry.credit_amounts.map{|a| ["", "", "",  "", "",  a.account.name, price(a.amount)] }, column_widths: [50, 100, 50, 100, 50, 100, 80], cell_style: {inline_format: true, padding: [0,0,2,0], size: 8} ) do
            cells.borders = []
            column(-1).align = :right
          end
          move_down 5
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
