class IncomeStatementPdf < Prawn::Document
  def initialize(revenues, expenses, employee, view_context)
    super(margin: 10, page_size: "A4", page_layout: :portrait)
    @revenues = revenues
    @expenses = expenses
    @employee = employee
    @view_context = view_context
    heading
  end
  private
  def heading
    bounding_box [0, 780], width: 100 do
      # image "#{@employee.cooperative_logo.path(:large)}", width: 50, height: 50, align: :center
    end
    bounding_box [0, 780], width: 530 do
      text "#{@employee.cooperative_name.upcase}", align: :center, style: :bold
      text "#{@employee.cooperative_address} | #{@employee.cooperative_contact_number}", size: 12, align: :center
      move_down 10
      text "INCOME STATEMENT", style: :bold, align: :center
      move_down 5
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
    end
  end
end

