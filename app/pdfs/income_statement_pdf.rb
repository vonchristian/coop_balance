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

  def logo
    {image: "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", image_width: 50, image_height: 50}
  end

  def subtable_right
    sub_data ||= [[{content: "#{cooperative.abbreviated_name}", size: 22}]] + [[{content: "#{cooperative.name}", size: 10}]]
    make_table(sub_data, cell_style: {padding: [0,5,1,2]}) do
      columns(0).width = 180
      cells.borders = []
    end
  end

  def subtable_left
    sub_data ||= [[{content: "INCOME STATEMENT", size: 14, colspan: 2}]] + 
                  [[{content: "As of #{to_date.strftime("%b. %e, %Y")}", size: 10, colspan: 2}]]
    make_table(sub_data, cell_style: {padding: [0,5,1,2]}) do
      columns(0).width = 50
      columns(1).width = 150
      cells.borders = []
    end
  end

  def heading # 275, 50, 210
    bounding_box [bounds.left, bounds.top], :width  => 535 do
      table([[subtable_left, logo, subtable_right]], 
        cell_style: { inline_format: true, font: "Helvetica", padding: [0,5,0,0]}, 
        column_widths: [310, 50, 180]) do
          cells.borders = []
      end
    end
    stroke do
      move_down 3
      stroke_color '24292E'
      line_width 1
      stroke_horizontal_rule
      move_down 1
    end
    move_down 10
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
    @revenues_data ||= revenues.uniq.map{|a| ["", a.name, price(a.balance(to_date: to_date))] }
  end

  def total_revenue
    [["", "<b>TOTAL REVENUES</b>", "<b>#{price(AccountingModule::Revenue.   balance(to_date: to_date))}</b>"]]
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
    @expenses_data ||= expenses.uniq.map{|a| ["", a.name, price(a.balance(to_date: to_date))] }
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

  def signatories
    move_down 30

    signatories_data ||= [["Prepared By:", "", "Certified Correct:", ""]] + [["", "", "", ""]] + [["", "", "", ""]] +
                          [["Prepared By:", "", "Certified Correct:", ""]]
    table(signatories_data, cell_style: { inline_format: true, size: 11, font: "Helvetica"}, column_widths: [120, 130, 120, 130]) do
      row(0).font_style = :bold
      cells.borders = []
      column(1).align =:right
    end
  end
end
