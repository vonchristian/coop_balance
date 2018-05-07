class TransactionSummaryPdf < Prawn::Document
  def initialize(employee, date, view_context)
    super(margin: 40, page_size: "A4", page_layout: :portrait)
    @employee = employee
    @date = date
    @view_context = view_context
    heading
    fund_transfers
    savings_deposits
    time_deposits
    share_capitals
    loan_releases
    loan_collections
    expenses
    revenues
    summary_report
    summary_of_accounts

  end
  private
  def price(number)
    @view_context.number_to_currency(number, :unit => "P ")
  end
  def heading
    bounding_box [300, 780], width: 50 do
      # image "#{Rails.root}/app/assets/images/kccmc_logo.jpg", width: 50, height: 50
    end
    bounding_box [370, 780], width: 200 do
        text "KCCMC", style: :bold, size: 24
        text "Kalanguya Cultural Community", size: 10
        text "Multipurpose Cooperative", size: 10

    end
    bounding_box [0, 780], width: 400 do
      text "Transactions Summary", style: :bold, size: 14
      move_down 3
      text "#{@date.strftime("%B %e, %Y")}", size: 10
      move_down 3

      text "Employee: #{@employee.name}", size: 10
    end
    move_down 15
    stroke do
      stroke_color '24292E'
      line_width 1
      stroke_horizontal_rule
      move_down 20
    end
  end
  def fund_transfers
    text "Fund Transfers",  color: "4A86CF", style: :bold, size: 10
    table(fund_transfers_data, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 150, 100]) do
      cells.borders = []
      column(2).align = :right

    end
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
    end
  end
  def fund_transfers_data
    [["", "Fund Transfer from Treasury"]]
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
    [["", "Beginning Balance", "#{price(CoopServicesModule::SavingProduct.all.map{ |a| a.account.balance(to_date: @date.yesterday.end_of_day) }.sum) }"]]
  end
  def add_savings_deposits
    [["", "", "Add Deposits", "#{price(CoopServicesModule::SavingProduct.all.map{|a| a.account.credits_balance(from_date: @date.beginning_of_day, to_date: @date.end_of_day)}.sum) }"]]
  end

  def less_savings_deposits
    [["", "", "Less Withdrawals", "#{price(CoopServicesModule::SavingProduct.all.map{|a| a.account.debits_balance(from_date: @date.beginning_of_day, to_date: @date.end_of_day)}.sum) }"]]
 end

  def total_savings_deposits
    [["", "", "Total Savings", "#{price(CoopServicesModule::SavingProduct.all.map{|a| a.account.balance(to_date: @date.end_of_day) }.sum) }"]]
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
    [["", "Beginning Balance", "#{price(CoopServicesModule::TimeDepositProduct.all.map{|a| a.account.balance(to_date: @date.yesterday.end_of_day) }.sum) }"]]
  end
  def time_deposits_from_members
    [["", "", "Add Deposits", "#{price(CoopServicesModule::TimeDepositProduct.all.map{|a| a.account.credits_balance(from_date: @date.beginning_of_day, to_date: @date.end_of_day) }.sum) }"]]
  end

  def time_deposit_withdrawals_from_members
    [["", "", "Less Withdrawals", "#{price(CoopServicesModule::TimeDepositProduct.all.map{|a| a.account.debits_balance(from_date: @date.beginning_of_day, to_date: @date.end_of_day) }.sum) }"]]
  end
  def total_time_deposits
    [["", "", "Total Time Deposits", "#{price(CoopServicesModule::TimeDepositProduct.all.map{|a| a.account.balance(to_date: @date.end_of_day) }.sum) }"]]

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
    [["", "Beginning Balance", "#{price(CoopServicesModule::ShareCapitalProduct.all.map{ |share_capital_product| share_capital_product.paid_up_account.balance(to_date: @date.yesterday.end_of_day) }.sum)}"]]
  end
  def additional_share_capital
    [["", "", "Additional Share Capital", "#{price(CoopServicesModule::ShareCapitalProduct.all.map{ |share_capital_product| share_capital_product.paid_up_account.credits_balance(from_date: @date.beginning_of_day, to_date: @date.end_of_day) }.sum)}"]]
  end
  def total_share_capitals
    [["", "", "Total Share Capitals", "#{price(CoopServicesModule::ShareCapitalProduct.all.map{ |share_capital_product| share_capital_product.paid_up_account.balance(from_date: @date.beginning_of_day, to_date: @date.end_of_day) }.sum)}"]]
  end
  def share_capital_withdrawals
    [["", "", "Less Withdrawals", "#{price(CoopServicesModule::ShareCapitalProduct.all.map{ |share_capital_product| share_capital_product.paid_up_account.debits_balance(to_date: @date.end_of_day) }.sum)}"]]
  end
  def loan_releases
    text "Loan Releases", style: :bold, size: 10, color: "DB4437"
    if @employee.disbursed_loan_vouchers.disbursed(from_date: @date.beginning_of_day, to_date: @date.end_of_day).present?

      table(loan_releases_data, header: true, cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [40, 160, 100, 110, 100]) do
        cells.borders = []
      end
    else
      text "No Loan released for #{@date.strftime("%B %e, %Y")}", size: 10
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
    if @employee.disbursed_loan_vouchers.disbursed(from_date: @date.beginning_of_day, to_date: @date.end_of_day).present?
       [["", "Borrower", "Voucher #", "Loan Amount", "Net Proceed"]] +
      @loan_releases_data ||= @employee.disbursed_loan_vouchers.disbursed(from_date: @date.beginning_of_day, to_date: @date.end_of_day).map{|a| ["", a.payee_name, a.number, price(a.payee.loan_amount), price(a.payee.net_proceed)]} +
      [["", "", "<b>TOTAL</b>", "<b>#{price(@employee.disbursed_loan_vouchers.disbursed(from_date: @date.beginning_of_day, to_date: @date.end_of_day).map{|a| a.payee.loan_amount}.sum) }</b>",  "<b>#{price(@employee.disbursed_loan_vouchers.disbursed(from_date: @date.beginning_of_day, to_date: @date.end_of_day).map{|a| a.payee.net_proceed}.sum) }</b>"]]
    end
  end

   def loan_collections
    text "Loan Collections", style: :bold, size: 10, color: "DB4437"
    if AccountingModule::Entry.loan_payments(employee_id: @employee.id, from_date: @date.beginning_of_day, to_date: @date.end_of_day).present?
      table(loan_collections_data, header: true, cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [40, 160, 100, 110, 100]) do
        cells.borders = []
      end
    else
      move_down 5
      text "    No Loan Collections for #{@date.strftime("%B %e, %Y")}", size: 10
    end
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 5
    end
  end

  def loan_collections_data
    if AccountingModule::Entry.loan_payments(employee_id: @employee.id, from_date: @date.beginning_of_day, to_date: @date.end_of_day).present?
       [["", "Borrower", "OR #", "Amount", ""]] +
      @loan_collections_data ||= AccountingModule::Entry.loan_payments(employee_id: @employee.id, from_date: @date.beginning_of_day, to_date: @date.end_of_day).uniq.map{|a| ["", a.commercial_document.try(:name), a.reference_number, price(a.debit_amounts.sum(&:amount))]} +
    [["", "", "<b>TOTAL</b>", "<b>#{price(AccountingModule::Entry.loan_payments(employee_id: @employee.id, from_date: @date.beginning_of_day, to_date: @date.end_of_day).uniq.map{|a| a.debit_amounts.sum(:amount)}.sum)}</b>", ""]]
    else
      [[""]]
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
    @expenses_data ||= AccountingModule::Expense.updated_at(from_date: @date.beginning_of_day, to_date: @date.end_of_day).distinct.map{|a| ["", "", a.name, price(a.debits_balance(to_date: @date.end_of_day))]} +
    [["", "", "<b>TOTAL</b>", "<b>#{price(AccountingModule::Expense.updated_at(from_date: @date.beginning_of_day, to_date: @date.end_of_day).map{ |a| a.balance(to_date: @date.end_of_day)}.sum )}</b>"]]
  end
  def revenues
    text "Other Income", style: :bold, size: 10, color: "DB4437"
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
    @revenues_data ||= AccountingModule::Revenue.updated_at(from_date: @date.beginning_of_day, to_date: @date.end_of_day).distinct.to_a.sort_by(&:balance).reverse.map{|a| ["", "", a.name, price(a.balance(from_date: @date, to_date: @date))]} +
    [["", "", "<b>TOTAL</b>", "#{AccountingModule::Revenue.updated_at(from_date: @date.beginning_of_day, to_date: @date.end_of_day).map{|a| a.balance(from_date: @date, to_date: @date) }.sum}"]]
  end

  def summary_report
    text "CASH ON HAND SUMMARY REPORT", style: :bold, size: 10
    table(summary_data, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 290, 90]) do
        cells.borders = []
    end
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
    end
   table(total_summary_data, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 290, 90]) do
        cells.borders = []
    end
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
    end
  end
  def summary_data
    [["", "", "Beginning Balance", "#{price(@employee.cash_on_hand_account.balance(to_date: @date.yesterday.end_of_day))}"]] +
    [["", "", "Cash Receipts", "#{price(@employee.cash_on_hand_account.debits_balance(from_date: @date.beginning_of_day, to_date: @date.end_of_day))}"]] +
    [["", "", "Cash Disbursements", "#{price(@employee.cash_on_hand_account.credits_balance(from_date: @date.beginning_of_day, to_date: @date.end_of_day))}"]]
  end
  def total_summary_data
    [["", "", "Ending Balance", "#{price(@employee.cash_on_hand_account_balance(to_date: @date.end_of_day))}"]]
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
      move_down 15
    end
  end
  def accounts_data
    [["", "Code", "Account", "Debits", "Credits"]] +
    @accounts_data ||= AccountingModule::Account.updated_at(from_date: @date.beginning_of_day, to_date: @date.end_of_day).updated_by(@employee).uniq.map{ |a| ["", a.code, a.name, price(a.debits_balance(from_date: @date.beginning_of_day, to_date: @date.end_of_day)), price(a.credits_balance(from_date: @date.beginning_of_day, to_date: @date.end_of_day))]}
  end


end
