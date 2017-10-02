module AccountingModule 
  class CollectionReportPdf < Prawn::Document 
    def initialize(entries, employee, view_context)
       super(margin: 20, page_size: "A4", page_layout: :portrait)
      @entries = entries 
      @employee = employee
      @view_context = view_context
      heading 
      entries_table
    end 
    private 
    def price(number)
      @view_context.number_to_currency(number, :unit => "P ")
    end
    def display_commercial_document_for(entry)
      if entry.commercial_document.try(:member).present? 
        entry.commercial_document.try(:member).try(:full_name)
      elsif 
        entry.fund_transfer?
        entry.commercial_document.try(:first_and_last_name)
      end
    end

    def heading 
      image "#{Rails.root}/app/assets/images/logo_grayscale.jpg", width: 50, height: 50
      move_down 5
      text "COLLECTION REPORT"
      if @employee.present?
        text "Employee: #{@employee.first_and_last_name}"
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
      table(table_data, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100]) do
        
        row(0).font_style = :bold
        row(0).background_color = 'DDDDDD'
        column(0).align = :right
        column(3).align = :right
      end
    end
  end

  def table_data
    move_down 5
    [["DATE", "DESCRIPTION", "REFERENCE NUMBER", "AMOUNT", "MEMBER", "EMPLOYEE"]] +
    @table_data ||= @entries.order(created_at: :asc).map { |e| [ e.entry_date.strftime("%b %e, %Y"), e.description, e.reference_number, price(e.debit_amounts.sum(&:amount)), display_commercial_document_for(e), e.recorder.try(:first_and_last_name)]} +
    [["TOTAL", "", "", "#{price(@entries.total)}"]]
  end
  end 
end 
