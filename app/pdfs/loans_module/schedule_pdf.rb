module LoansModule
  class SchedulePdf < Prawn::Document
    attr_reader :date, :schedules, :employee, :view_context
    def initialize(date, schedules, employee, view_context)
      super(margin: 30, page_size: "LEGAL", page_layout: :portrait)
      @date = date
      @schedules = schedules
      @employee = employee
      @view_context = view_context
      heading
      schedules_table
    end
    private
    def format_interest(schedule)
      if schedule.prededucted_interest?
        "DEDUCTED"
      else
        price(schedule.interest)
      end
    end

    def price(number)
      view_context.number_to_currency(number, :unit => "P ")
    end
    def heading

    bounding_box [360, 930], width: 200 do
        text "KALANGUYA CULTURAL COMMUNITY", style: :bold, size: 8
        text "MULTIPURPOSE COOPERATIVE", style: :bold, size: 8
        move_down 5
        text "Poblacion, Tinoc, Ifugao", size: 7
    end
    bounding_box [0, 930], width: 400 do
      text "AMORTIZATION SCHEDULE", style: :bold, size: 10
      move_down 5
      text "Date: #{@date.to_date.strftime("%B %e, %Y")}", size: 9
      move_down 6

      text "", size: 10
    end
    move_down 15
    stroke do
      stroke_color '24292E'
      line_width 1
      stroke_horizontal_rule
      move_down 5
    end
  end
    def schedules_table
      table(table_data, header: true, cell_style: { size: 9, font: "Helvetica"}, column_widths: [90, 90, 90, 70, 70, 70, 70]) do
        column(4).align = :right
        column(5).align = :right
        column(6).align = :right
        row(0).font_style = :bold
        row(0).background_color = 'DDDDDD'
      end
    end

    def table_data
      move_down 5
      [["Borrower", "Loan Product", "Address", "Contact Number", "Principal", "Interest", "Total"]] +
      @table_data ||= schedules.map { |e| [
        e.loan.try(:borrower_name),
        e.loan.loan_product_name,
        e.loan.try(:borrower_current_address),
        e.loan.try(:borrower_contact_number),
        price(e.principal),
        format_interest(e),
        price(e.total_amortization)]}
    end
  end
end
