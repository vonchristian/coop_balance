require 'prawn/icon'
class TransactionSummaryPdf < Prawn::Document
  attr_reader :employee, :date, :view_context, :cooperative
  def initialize(args={})
    super(margin: 30, page_size: "A4", page_layout: :portrait)
    @employee = args[:employee]
    @cooperative = @employee.cooperative
    @date = args[:date]
    @view_context = args[:view_context]
    heading
    cash_books
    savings_deposits
    time_deposits
    share_capitals
    loan_releases
    loan_collections
    expenses
    revenues
    summary_of_accounts
    font Rails.root.join("app/assets/fonts/open_sans_light.ttf")
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
      text "TRANSACTIONS SUMMARY", style: :bold, size: 12
      text "Date: #{date.strftime("%B %e, %Y")}", style: :bold, size: 10
    end
    move_down 30
    stroke do
      stroke_color '24292E'
      line_width 1
      stroke_horizontal_rule
      move_down 5
    end
  end
  def cash_books
    text "Cash Accounts",  color: "4A86CF", style: :bold, size: 10
    table(cash_books_data, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 140, 110, 110, 110]) do
      cells.borders = []
      column(2).align = :right
      column(3).align = :right
      column(4).align = :right


    end
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
    end
  end
  def cash_books_data
    [["", "ACCOUNT", "DEBITS", "CREDITS", "BALANCE"]] +
    @cash_books_data ||= cooperative.cash_accounts.map{ |a|["", a.name, price(a.debits_balance(to_date: date)), price(a.credits_balance(to_date: date)), price(a.balance(to_date: date))]}
  end
    def savings_deposits
     text "Savings Deposits", style: :bold, size: 10,  color: "4A86CF"
      table(savings_deposits_balances, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 150, 100]) do
      cells.borders = []
      column(2).align = :right

      end
      table(add_savings_deposits, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 150, 90]) do
      cells.borders = []
      row(0).text_color = "008751"
      column(3).align = :right
      end
      table(less_savings_deposits, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 150, 90]) do
        cells.borders = []
        row(0).text_color = "DB4437"
        column(3).align = :right
      end
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.1
        stroke_horizontal_rule
    end
      table(total_savings_deposits, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 150, 90]) do
        cells.borders = []
        row(0).font_style = :bold
        column(3).align = :right
      end
    stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
    end
  end
  #Savings Deposits
  def savings_deposits_balances
    [["", "Beginning Balance", "#{price(cooperative.saving_products.total_balance(to_date: date.yesterday.end_of_day)) }"]]
  end
  def add_savings_deposits
    [["", "", "Add Deposits", "#{price(cooperative.saving_products.total_credits_balance(from_date: date.beginning_of_day, to_date: date.end_of_day)) }"]]
  end

  def less_savings_deposits
    [["", "", "Less Withdrawals", "#{price(cooperative.saving_products.total_debits_balance(from_date: date.beginning_of_day, to_date: date.end_of_day)) }"]]
 end

  def total_savings_deposits
    [["", "", "Total Savings", "#{price(cooperative.saving_products.total_balance(to_date: date.end_of_day)) }"]]
  end

  def time_deposits
    text "Time Deposits", style: :bold, size: 10, color: "4A86CF"
  table(time_deposits_balances, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 150, 100]) do
      cells.borders = []
      column(2).align = :right
      end
      table(time_deposits_from_members, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 150, 90]) do
        cells.borders = []
        row(0).text_color = "008751"
        column(3).align = :right
      end
      table(time_deposit_withdrawals_from_members, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 150, 90]) do
        cells.borders = []
        row(0).text_color = "DB4437"
        column(3).align = :right
      end
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.1
        stroke_horizontal_rule
    end
      table(total_time_deposits, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 150, 90]) do
        cells.borders = []
        row(0).font_style = :bold
        column(3).align = :right
      end
    stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
    end
  end
  def time_deposits_balances
    [["", "Beginning Balance", "#{price(cooperative.time_deposit_products.total_balance(to_date: date.yesterday.end_of_day)) }"]]
  end
  def time_deposits_from_members
    [["", "", "Add Deposits", "#{price(cooperative.time_deposit_products.total_credits_balance(from_date: date.beginning_of_day, to_date: date.end_of_day)) }"]]
  end

  def time_deposit_withdrawals_from_members
    [["", "", "Less Withdrawals", "#{price(cooperative.time_deposit_products.total_debits_balance(from_date: date.beginning_of_day, to_date: date.end_of_day)) }"]]
  end
  def total_time_deposits
    [["", "", "Total Time Deposits", "#{price(cooperative.time_deposit_products.total_balance(to_date: date.end_of_day)) }"]]

  end

  def share_capitals
    text "Share Capitals", style: :bold, size: 10, color: "4A86CF"
    table(share_capital_beginning_balance, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 150, 100]) do
      cells.borders = []
      column(2).align = :right
    end
      table(additional_share_capital, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 150, 90]) do
      cells.borders = []
      row(0).text_color = "008751"
      column(3).align = :right
      end
      table(share_capital_withdrawals, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 150, 90]) do
        cells.borders = []
        row(0).text_color = "DB4437"
        column(3).align = :right
      end
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.1
        stroke_horizontal_rule
    end
      table(total_share_capitals, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 150, 90]) do
        cells.borders = []
        row(0).font_style = :bold
        column(3).align = :right
      end
    stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
    end
  end
  def share_capital_beginning_balance
    [["", "Beginning Balance", "#{price(cooperative.share_capital_products.total_balance(to_date: date.yesterday.end_of_day))}"]]
  end
  def additional_share_capital
    [["", "", "Additional Share Capital", "#{price(cooperative.share_capital_products.total_credits_balance(from_date: date, to_date: date))}"]]
  end
  def total_share_capitals
    [["", "", "Total Share Capitals", "#{price(cooperative.share_capital_products.total_balance(to_date: date))}"]]
  end
  def share_capital_withdrawals
    [["", "", "Less Withdrawals", "#{price(cooperative.share_capital_products.total_debits_balance(from_date: date, to_date: date))}"]]
  end
  def loan_releases
    text "Loan Releases", style: :bold, size: 10, color: "DB4437"
    if LoansModule::Loan.disbursed.disbursed_on(from_date: date, to_date: date).disbursed_by(employee_id: employee.id).present?

      table(loan_releases_data, header: true, cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [10, 150, 50, 100, 100, 100, 100]) do
        cells.borders = []
      end
    else
      text "No Loan released for #{date.strftime("%B %e, %Y")}", size: 10
      move_down 10
    end
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 10
    end
  end

  def loan_releases_data
    if LoansModule::Loan.disbursed(from_date: from_date, to_date: to_date).disbursed_by(employee_id: employee.id).present?
       [["", "Borrower", "Voucher #", "Loan Amount", "Net Proceed"]] +
      loan_releases_data ||= cooperative.loans.disbursed(from_date: from_date, to_date: to_date).disbursed_by(employee_id: employee.id).map{|a| ["", a.borrower_name, "", price(a.loan_amount), price(a.net_proceed)]}
       end
  end

   def loan_collections
    text "Loan Collections", style: :bold, size: 10, color: "DB4437"
    # if cooperative.entries.loan_payments.recorded_by(recorder: employee).entered_on(from_date: date, to_date: date).present?
      table([["", "Borrower", "OR #", "Principal", "Interest", "Penalty", "Total"]], header: true, cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [10, 120, 70, 70, 70, 70, 100]) do
        cells.borders = []
        column(3).align = :right
        column(4).align = :right
        column(5).align = :right
        column(6).align = :right


      end
    # else
    #   move_down 5
    #   text "    No Loan Collections for #{date.strftime("%B %e, %Y")}", size: 10
    # end
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 5
    end

    cooperative.entries.loan_payments.recorded_by(recorder: employee).entered_on(from_date: date, to_date: date).order(entry_date: :desc).each do |entry|
      table(
        cooperative.loans.for_entry(entry: entry).map{ |a| ["", "#{a.borrower_name}","#{entry.reference_number}", price(entry.credit_amounts.loan_principal_amount(loan: a)), price(entry.credit_amounts.loan_interest_amount(loan: a)), price(entry.credit_amounts.loan_penalty_amount(loan: a)), price(entry.credit_amounts.total_loan_payment(loan: a))] }, column_widths: [10, 120, 70, 70, 70, 70, 100], cell_style: { inline_format: true, size: 9, padding: [0,0,0,0]}) do
        cells.borders = []
        column(3).align = :right
        column(4).align = :right
        column(5).align = :right
        column(6).align = :right
      end
    table(
      cooperative.loans.for_entry(entry: entry).map{ |a| ["", "","", price(entry.credit_amounts.loan_principal_amount), price(entry.credit_amounts.loan_interest_amount(loan: a)), price(entry.credit_amounts.loan_penalty_amount(loan: a)), price(entry.credit_amounts.total_loan_payment(loan: a))] }, column_widths: [10, 120, 70, 70, 70, 70, 100], cell_style: { inline_format: true, size: 9, padding: [0,0,0,0]}) do
      cells.borders = []
      column(3).align = :right
      column(4).align = :right
      column(5).align = :right
      column(6).align = :right
    end
  end
  end


  def expenses
    text "Expenses", style: :bold, size: 10, color: "DB4437"
    table(expenses_data, cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [10, 10, 290, 90]) do
        cells.borders = []
        row(0).font_style = :bold
    end
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
    end

    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
    end
  end
  def expenses_data
    [["", "", "Account", "Amount"]] +
    expenses_data ||= cooperative.accounts.expenses.updated_at(from_date: date.beginning_of_day, to_date: date.end_of_day).distinct.map{|a| ["", "", a.name, price(a.debits_balance(to_date: date.end_of_day))]} +
    [["", "", "<b>TOTAL</b>", "<b>#{price(cooperative.accounts.expenses.updated_at(from_date: date.beginning_of_day, to_date: date.end_of_day).map{ |a| a.debits_balance(to_date: date.end_of_day)}.sum )}</b>"]]
  end
  def revenues
    text "Revenue", style: :bold, size: 10, color: "DB4437"
    table(revenues_data, cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [10, 10, 290, 90]) do
        cells.borders = []
        row(0).font_style = :bold
    end
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
    end

    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
    end
  end
  def revenues_data
    [["", "", "Account", "Amount"]] +
    revenues_data ||= cooperative.accounts.revenues.updated_at(from_date: date.beginning_of_day, to_date: date.end_of_day).distinct.to_a.sort_by(&:balance).reverse.map{|a| ["", "", a.name, price(a.credits_balance(from_date: date, to_date: date))]} +
    [["", "", "<b>TOTAL</b>", "#{cooperative.accounts.revenues.updated_at(from_date: date.beginning_of_day, to_date: date.end_of_day).map{|a| a.credits_balance(from_date: date, to_date: date) }.sum}"]]
  end


  def summary_of_accounts
    text "Summary of Accounts", style: :bold, size: 10

    table(accounts_data, cell_style: { size: 10, font: "Helvetica"}, column_widths: [20, 80, 210, 90]) do
        cells.borders = []
        row(0).font_style = :bold
        column(3).align = :right
        column(4).align = :right
    end
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 5
    end
    table(accounts_total_data, cell_style: { size: 10, font: "Helvetica"}, column_widths: [20, 80, 210, 90]) do
        cells.borders = []
        row(0).font_style = :bold
        column(3).align = :right
        column(4).align = :right
    end
  end
  def accounts_data
    [["", "Code", "Account", "Debits", "Credits"]] +
    accounts_data ||= cooperative.accounts.updated_at(from_date: date.beginning_of_day, to_date: date.end_of_day).updated_by(employee).uniq.map{ |a| ["", a.code, a.name, price(a.debits_balance(from_date: date.beginning_of_day, to_date: date.end_of_day)), price(a.credits_balance(from_date: date.beginning_of_day, to_date: date.end_of_day))]}
  end
  def accounts_total_data
    [["",
      "",
      "",
      "#{price cooperative.accounts.updated_at(from_date: date.beginning_of_day, to_date: date.end_of_day).updated_by(employee).debits_balance(from_date: @date, to_date: @date) }",
      "#{price cooperative.accounts.updated_at(from_date: date.beginning_of_day, to_date: date.end_of_day).updated_by(employee).credits_balance(from_date: @date, to_date: @date) }"]]

  end


end
