module LoansModule 
  class SchedulePdf < Prawn::Document 
    def initialize(date, schedules, view_context)
      super(margin: 40, page_layout: :portrait)
      @date = date 
      @schedules = schedules
      @view_context = view_context
      heading
      schedules_table
    end
    private 
    def price(number)
      @view_context.number_to_currency(number, :unit => "P ")
    end
    def heading
      text "Scheduled Payments for #{@date.to_date.strftime("%B %e, %Y")}", align: :center, style: :bold, size: 14
      stroke_horizontal_rule
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
      [["Member", "Amount"]] + 
      @table_data ||= @schedules.map { |e| [e.amortizeable.try(:member_full_name), price(e.total_amortization)]}
    end
  end 
end 
