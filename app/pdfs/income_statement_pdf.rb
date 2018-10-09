class IncomeStatementPdf < Prawn::Document
  attr_reader :revenues, :expenses, :employee, :from_date, :to_date, :view_context, :cooperative
  def initialize(args={})
    super(margin: 40, page_size: "A4", page_layout: :portrait)
    @revenues     = args[:revenues]
    @expenses     = args[:expenses]
    @employee     = args[:employee]
    @from_date    = args[:from_date]
    @to_date      = args[:to_date]
    @view_context = args[:view_context]
    heading
    show_revenues
    show_expenses
    net_surplus
  end

  private
  def price(number)
    view_context.number_to_currency(number, :unit => "P ")
  end

  def heading
    bounding_box [300, 770], width: 50 do
      image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 50, height: 50
    end
    bounding_box [360, 770], width: 200 do
        text "#{cooperative.abbreviated_name }", style: :bold, size: 20
        text "#{cooperative.name.try(:upcase)}", size: 8
        text "#{cooperative.address}", size: 8
    end
    bounding_box [0, 770], width: 400 do
      text "Income Statement", style: :bold, size: 12

    end
    move_down 30
    stroke do
      stroke_color '24292E'
      line_width 1
      stroke_horizontal_rule
      move_down 5
    end
  end

  def show_revenues
    text "REVENUES", style: :bold
    table(revenues_data, cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [300, 100]) do
      cells.borders =[]
      column(1).align = :right
      row(-1).font_style = :bold
    end
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
    end
  end

  def revenues_data
    [["", ""]] +
    @revenues_data ||= revenues.map{|a| [a.name, price(a.balance(to_date: to_date))] } +
    [["TOTAL REVENUES", "#{price(AccountingModule::Revenue.balance(to_date: to_date))}"]]
  end

  def show_expenses
    text "Expenses", style: :bold
    table(expenses_data, cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [300, 100]) do
      cells.borders =[]
      column(1).align = :right
      row(-1).font_style = :bold
    end
  end

  def expenses_data
    [["", ""]] +
    @expenses_data ||= expenses.map{|a| [a.name, price(a.balance(to_date: to_date))] } +
    [["TOTAL EXPENSES", "#{price(AccountingModule::Expense.balance(to_date: to_date))}"]]

  end

  def net_surplus
   stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
    end
    table([["NET SURPLUS", "#{price(AccountingModule::Revenue.balance(to_date: to_date) - AccountingModule::Expense.balance(to_date: to_date))}"]], cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [300, 100]) do
      row(0).font_style = :bold
      cells.borders = []
      column(1).align =:right
    end
  end
end
