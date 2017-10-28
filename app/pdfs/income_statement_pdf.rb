class IncomeStatementPdf < Prawn::Document
  def initialize(revenues, expenses, employee, from_date, to_date, view_context)
    super(margin: 40, page_size: "A4", page_layout: :portrait)
    @revenues = revenues
    @expenses = expenses
    @employee = employee
    @from_date = from_date
    @to_date = to_date
    @view_context = view_context
    heading
    show_revenues
    show_expenses
  end
  private
  def heading
    bounding_box [300, 760], width: 50 do
      image "#{Rails.root}/app/assets/images/logo_kcmdc.jpg", width: 40, height: 40
    end
    bounding_box [350, 760], width: 150 do
        text "KCMDC", style: :bold, size: 22
        text "Poblacion, Kiangan, Ifugao", size: 10
    end
    bounding_box [0, 760], width: 400 do
      text "Income Statement", style: :bold, size: 14
      move_down 5
      text "#{@from_date.strftime("%B %e, %Y")} - #{@to_date.strftime("%B %e, %Y")} ", size: 10
      move_down 5
    end
    move_down 10
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
    end
  end
  def show_revenues
    text "Sales", style: :bold
    table(revenues_data) do
      cells.borders =[]
    end
  end
  def revenues_data
    [["", ""]] +
    @revenues_data ||= @revenues.map{|a| [a.name, a.balance] }
  end
  def show_expenses
    text "Expenses", style: :bold
    table(expenses_data) do
      cells.borders =[]
    end
  end
  def expenses_data
    [["", ""]] +
    @expenses_data ||= @expenses.map{|a| [a.name, a.balance] }
  end
end

