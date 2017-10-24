module LoansModule 
  class SchedulePdf < Prawn::Document 
    def initialize(date, schedules, employee, view_context)
      super(margin: 30, page_size: "A4", page_layout: :portrait)
      @date = date 
      @schedules = schedules
      @employee = employee
      @view_context = view_context
      heading
      schedules_table
    end
    private 
    def price(number)
      @view_context.number_to_currency(number, :unit => "P ")
    end
    def heading 
      bounding_box [0, 780], width: 100 do
        image "#{@employee.cooperative_logo.path(:large)}", width: 50, height: 50, align: :center
      end 
      bounding_box [0, 780], width: 530 do
        text "#{@employee.cooperative_name.upcase}", align: :center, style: :bold
        text "#{@employee.cooperative_address} | #{@employee.cooperative_contact_number}", size: 12, align: :center
      

        move_down 10
        text "PAYMENT SCHEDULE FOR #{@date.to_date.strftime("%B %e, %Y")}", style: :bold, align: :center
        move_down 5
        stroke do
          stroke_color 'CCCCCC'
          line_width 0.2
          stroke_horizontal_rule
          move_down 15
        end
      end
    end 
    def schedules_table
      table(table_data, header: true, cell_style: { size: 12, font: "Helvetica"}) do
        column(1).align = :right
        row(0).font_style = :bold
        row(0).background_color = 'DDDDDD'
      end
    end

    def table_data
      move_down 5
      [["Member", "Address", "Contact Number", "Amount"]] + 
      @table_data ||= @schedules.map { |e| [e.amortizeable.try(:borrower_name), e.amortizeable.try(:borrower_current_address), e.amortizeable.try(:borrower_contact_number), price(e.total_amortization)]}
    end
  end 
end 
