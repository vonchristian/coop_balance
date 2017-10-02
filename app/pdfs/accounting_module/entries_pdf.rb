module AccountingModule 
  class EntriesPdf < Prawn::Document 
    def initialize(entries, employee, view_context)
       super(margin: 40, page_size: "A4", page_layout: :portrait)
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
    def heading 
      image "#{Rails.root}/app/assets/images/logo_grayscale.jpg", width: 50, height: 50
      move_down 5
      text "DISBURSEMENT REPORT"
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
        
        # row(0).font_style = :bold
        # row(0).background_color = 'DDDDDD'
        column(0).align = :right
        column(3).align = :right
        column(4).align = :right
      end
    end
  end

  def table_data
    move_down 5
    [["DATE", "DESCRIPTION", "REFERENCE NUMBER", "AMOUNT", "MEMBER", "EMPLOYEE"]] +
    @table_data ||= @entries.map { |e| [ e.entry_date.strftime("%B %e, %Y"), e.description, e.reference_number, price(e.debit_amounts.sum(&:amount)), e.commercial_document.try(:member).try(:full_name), e.recorder.try(:first_and_last_name)]}
  end
  end 
end 
