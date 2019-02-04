class IncomeStatementPdf < Prawn::Document
  attr_reader :revenues, :expenses, :employee, :from_date, :to_date, :view_context, :cooperative
  def initialize(args={})
    super(margin: 40, page_size: "A4", page_layout: :portrait)
    @revenues     = args[:revenues]
    @expenses     = args[:expenses]
    @employee     = args[:employee]
    @cooperative  = @employee.cooperative
    @from_date    = args[:from_date]
    @to_date      = args[:to_date]
    @view_context = args[:view_context]
    heading
    revenue_accounts
    expense_accounts
    net_surplus
    font Rails.root.join("app/assets/fonts/open_sans_light.ttf")
  end

  private
  def price(number)
    view_context.number_to_currency(number, :unit => "P ")
  end

  def heading
    bounding_box [320, 770], width: 50 do
      image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 50, height: 50
    end
    bounding_box [380, 770], width: 160 do
        text "#{cooperative.abbreviated_name }", style: :bold, size: 20
        text "#{cooperative.name.try(:upcase)}", size: 8
        text "#{cooperative.address}", size: 8
    end
    bounding_box [0, 770], width: 400 do
      text "INCOME STATEMENT", style: :bold, size: 12
      text "Date Covered:", size: 10
      text "#{from_date.strftime("%b. %e, %Y")} - #{to_date.strftime("%b. %e, %Y")}", size: 10, indent_paragraphs: 30
    end
    move_down 20
    stroke do
      stroke_color '24292E'
      line_width 1
      stroke_horizontal_rule
      move_down 15
    end
  end

  def revenue_accounts
    text "REVENUES", size: 12, style: :bold
    move_down 5
    table(revenues_data, cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [10, 385, 120]) do
      cells.borders =[:bottom]
      column(2).align = :right
    end
    move_down 2
    table(total_revenue, header: true, cell_style: { inline_format: true, size: 11, font: "Helvetica"}, column_widths: [10, 385, 120]) do
      cells.borders = [:top, :bottom]
      column(2).align = :right
    end
  end

  def revenues_data
    @revenues_data ||= revenues.select{|r| !r.balance(to_date: to_date).round(2).zero?}.uniq.map{|a| ["", a.name, price(a.balance(to_date: to_date))] }
  end

  def total_revenue
    [["", "<b>TOTAL REVENUES</b>", "<b>#{price(AccountingModule::Revenue.balance(to_date: to_date))}</b>"]]
  end

  def expense_accounts
    move_down 20
    text "EXPENSES", size: 12, style: :bold
    move_down 5
    table(expenses_data, cell_style: { inline_format: true, size: 11, font: "Helvetica"}, column_widths: [10, 385, 120]) do
      cells.borders =[:bottom]
      column(2).align = :right
    end
    move_down 2
    table(total_expenses, header: true, cell_style: { inline_format: true, size: 11, font: "Helvetica"}, column_widths: [10, 385, 120]) do
      cells.borders = [:top, :bottom]
      column(2).align = :right
    end
  end

  def expenses_data
    @expenses_data ||= expenses.select{|r| !r.balance(to_date: to_date).round(2).zero?}.uniq.map{|a| ["", a.name, price(a.balance(to_date: to_date))] }
  end

  def total_expenses
    [["", "<b>TOTAL EXPENSES</b>", "<b>#{price(AccountingModule::Expense.balance(to_date: to_date))}</b>"]]
  end

  def net_surplus
    move_down 10
    table([["NET SURPLUS", "#{price(AccountingModule::Account.net_surplus(to_date: to_date))}"]], cell_style: { inline_format: true, size: 11, font: "Helvetica"}, column_widths: [395, 120]) do
      row(0).font_style = :bold
      cells.borders = []
      column(1).align =:right
    end
  end
end
