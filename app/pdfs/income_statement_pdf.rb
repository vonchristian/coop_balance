class IncomeStatementPdf < Prawn::Document
  attr_reader :revenues, :expenses, :employee, :from_date, :to_date, :view_context, :cooperative, :office
  def initialize(args={})
    super(margin: 40, page_size: "A4", page_layout: :portrait)
    @revenues     = args[:revenues]
    @expenses     = args[:expenses]
    @employee     = args[:employee]
    @cooperative  = @employee.cooperative
    @office       = @employee.office
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
    table(revenues_data, header: false, 
      cell_style: { size: 9, font: "Helvetica"}, 
      column_widths: [401, 100]) do
      cells.borders = [:bottom]
      column(1).align = :right
    end
    move_down 2
    table(total_revenues_data, header: true, 
      cell_style: { inline_format: true, size: 11, font: "Helvetica", padding: [1,3,2,1]}, 
      column_widths: [10, 10, 10, 371, 100]) do
      cells.borders = [:top, :bottom]
      column(4).align = :right
    end
  end

  def revenues_data
    accounts_array = []
    office.accounts.active.revenues.order(:code).each do |account|
      revenue_and_expense_accounts(account: account, accounts_array: accounts_array)
    end
    accounts_array
  end
  def total_revenues_data
    [["", {content: "TOTAL REVENUES ", colspan: 3, font_style: :bold}, "<b>#{price(office.accounts.active.revenues.balance(from_date: from_date, to_date: to_date))}</b>"]]
  end

  def expense_accounts
    move_down 20
    text "EXPENSES", size: 12, style: :bold
    table(expenses_data, header: false, 
      cell_style: { size: 9, font: "Helvetica"}, 
      column_widths: [401, 100]) do
      cells.borders = [:bottom]
      column(1).align = :right
    end
    move_down 2
    table(total_expenses_data, header: true, 
      cell_style: { inline_format: true, size: 11, font: "Helvetica", padding: [1,3,2,1]}, 
      column_widths: [10, 10, 10, 371, 100]) do
      cells.borders = [:top, :bottom]
      column(4).align = :right
    end
  end

  def expenses_data
    accounts_array = []
    office.accounts.active.expenses.order(:code).each do |account|
      revenue_and_expense_accounts(account: account, accounts_array: accounts_array)
    end
    accounts_array
  end
  def total_expenses_data
    [["", {content: "TOTAL EXPENSES ", colspan: 3, font_style: :bold}, "<b>#{price(office.accounts.active.expenses.balance(from_date: from_date, to_date: to_date))}</b>"]]
  end

  def net_surplus
    move_down 10
    table([[{ content: "NET SURPLUS", colspan: 4, font_style: :bold}, "#{price(office.accounts.active.net_surplus(from_date: from_date, to_date: to_date))}"]], 
      header: true, cell_style: { inline_format: true, size: 11, font: "Helvetica", padding: [1,3,2,1]}, 
      column_widths: [10, 10, 10, 371, 100]) do
      row(0).font_style = :bold
      cells.borders = []
      column(4).align =:right
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

  def account_balance(account)
    if !account.balance(from_date: from_date, to_date: to_date).zero?
      price(account.balance(from_date: from_date, to_date: to_date))
    else
      ""
    end
  end

  def revenue_and_expense_accounts(args={})
    account = args[:account]
    accounts_array = args[:accounts_array]
    if account.main_account.blank? #base account
      accounts_array << [{content: account.name, padding: [1,3,2,10], font_style: :bold}, {content:account_balance(account), padding: [1,3,2,1]}]
    elsif account.main_account.present? && account.main_account.main_account.blank? #sub_base
      if !office.accounts.active.accounts_under(account: account).balance(from_date: from_date, to_date: to_date).zero?
        accounts_array << [{content: account.name, padding: [1,3,2,20]}, {content:account_balance(account), padding: [1,3,2,1]}]
      else #sub_accounts balance not zero and account balance not zero either.
        accounts_array << [{content: account.name, padding: [1,3,2,20]}, {content:account_balance(account), padding: [1,3,2,1]}] if !account.balance(from_date: from_date, to_date: to_date).zero?
      end
    elsif account.main_account.main_account.present? #sub_account
      accounts_array << [{content: account.name, padding: [1,3,2,30]}, {content:account_balance(account), padding: [1,3,2,1]}] if !account.balance(from_date: from_date, to_date: to_date).zero?
    end
  end
end
