class TellerReportPdf < Prawn::Document
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
    summary_report
    summary_of_accounts

  end
  private
  def price(number)
    @view_context.number_to_currency(number, :unit => "P ")
  end
   def heading
    bounding_box [300, 780], width: 50 do
      image "#{Rails.root}/app/assets/images/logo_kcmdc.jpg", width: 50, height: 50
    end
    bounding_box [370, 780], width: 200 do
        text "KCMDC", style: :bold, size: 24
        text "Kiangan Community Multipurpose Cooperative", size: 10
    end
    bounding_box [0, 780], width: 400 do
      text "Teller's Blotter", style: :bold, size: 14
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
    table([["", "Fund Transfer from Treasury", "#{price(100)}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 150, 100]) do
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
    def savings_deposits
     text "Savings Deposits", style: :bold, size: 10,  color: "4A86CF"
      table(savings_deposits_balances, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 150, 100]) do
      cells.borders = []
      column(2).align = :right

      end
      table(savings_deposits_from_members, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 150, 90]) do
      cells.borders = []
      row(0).text_color = "008751"
      column(3).align = :right
      end
      table(withdrawals_from_members, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 150, 90]) do
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
    [["", "Beginning Balance", "#{price(AccountingModule::Account.find_by(name: "Savings Deposits").balance(to_date: @date.yesterday.end_of_day))}"]]
  end
  def savings_deposits_from_members
    [["", "", "Add Deposits", "#{price(AccountingModule::Account.find_by(name: "Savings Deposits").credit_entries.recorder_by(@employee.id).entered_on(from_date: @date, to_date: @date).total)}"]]
  end
  def total_savings_deposits
    [["", "", "Total Savings Deposits", "#{price(AccountingModule::Account.find_by(name: "Savings Deposits").balance)}"]]
  end
  def withdrawals_from_members
    [["", "", "Less Withdrawals", "#{price(AccountingModule::Account.find_by(name: "Savings Deposits").debit_entries.recorder_by(@employee.id).entered_on(from_date: @date, to_date: @date).total)}"]]
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
    [["", "Beginning Balance", "#{price(AccountingModule::Account.find_by(name: "Savings Deposits").balance(to_date: (@date.yesterday.end_of_day - 1.second), recorder_id: @employee.id))}"]]
  end
  def time_deposits_from_members
    [["", "", "Add Deposits", "#{price(AccountingModule::Account.find_by(name: "Time Deposits").credit_entries.recorder_by(@employee.id).entered_on(from_date: @date, to_date: @date).total)}"]]
  end
  def total_time_deposits
    [["", "", "Total Savings Deposits", "#{price(AccountingModule::Account.find_by(name: "Time Deposits").balance(:recorder_id => @employee.id))}"]]
  end
  def time_deposit_withdrawals_from_members
    [["", "", "Less Withdrawals", "#{price(AccountingModule::Account.find_by(name: "Time Deposits").debit_entries.recorder_by(@employee.id).entered_on(from_date: @date, to_date: @date).total)}"]]
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
    [["", "Beginning Balance", "#{price(AccountingModule::Account.find_by(name: "Paid-up Share Capital - Common").balance(to_date: @date.yesterday, recorder_id: @employee.id))}"]]
  end
  def additional_share_capital
   [["", "", "Additional Share Capital", "#{price(AccountingModule::Account.find_by(name: "Paid-up Share Capital - Common").balance(:recorder_id => @employee.id))}"]]
  end
  def total_share_capitals
    [["", "", "Total Share Capitals", "#{price(AccountingModule::Account.find_by(name: "Paid-up Share Capital - Common").balance(to_date: @date.end_of_day, :recorder_id => @employee.id))}"]]
  end
  def share_capital_withdrawals
    [["", "", "Less Withdrawals", "#{price(AccountingModule::Account.find_by(name: 'Paid-up Share Capital - Common').debit_entries.recorder_by(@employee.id).entered_on(from_date: @date, to_date: @date).total)}"]]
  end
  def loan_releases
    text "Loan Releases", style: :bold, size: 10, color: "DB4437"
    table(loan_releases_header, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [40, 160, 100, 110, 100]) do
      cells.borders = []
    end
    table(loan_releases_data, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [40, 160, 100, 110, 100]) do
      cells.borders = []
    end
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
    end
    table(loan_releases_total, header: true, cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [40, 160, 100, 110, 100]) do
      cells.borders = []
    end
  end
  def loan_releases_header
    [["", "Borrower", "Voucher #", "Loan Amount", "Net Proceed"]]
  end
  def loan_releases_data
    if @employee.entries.loan_disbursement.present?
      @loan_releases_data ||= @employee.entries.loan_disbursement.map{|a| [ {image: a.commercial_document.borrower.avatar.path(:medium), image_height: 30, image_width: 30 }, a.commercial_document.try(:borrower_name), a.reference_number, price(a.commercial_document.loan_amount), price(a.commercial_document.net_proceed)]}
    else
      [["", "", "", "No Loan releases"]]
    end
  end

  def loan_releases_total

      [["", "", "", "<b>#{price(@employee.entries.loan_disbursement.map{|a| a.debit_amounts.distinct.sum(:amount)}.sum)}</b>", "Net Proceed"]]

  end

   def loan_collections
    text "Loan Collections", style: :bold, size: 10, color: "DB4437"
    table(loan_collections_header, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [40, 160, 100, 110, 100]) do
      cells.borders = []
    end
    table(loan_collections_data, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [40, 160, 100, 110, 100]) do
      cells.borders = []
    end
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
    end
    table(loan_collections_total, header: true, cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [40, 160, 100, 110, 100]) do
      cells.borders = []
    end
  end
  def loan_collections_header
    [["", "Borrower", "OR #", "Loan Amount", "Net Proceed"]]
  end
  def loan_collections_data
    if @employee.entries.loan_disbursement.present?

      @loan_collections_data ||= @employee.entries.loan_disbursement.map{|a| [ {image: a.commercial_document.borrower.avatar.path(:medium), image_height: 30, image_width: 30 }, a.commercial_document.try(:borrower_name), a.reference_number, price(a.commercial_document.loan_amount), price(a.commercial_document.net_proceed)]}
    else
      [[""]]
    end
  end

  def loan_collections_total
    [["", "", "", "<b>#{price(@employee.entries.loan_disbursement.map{|a| a.debit_amounts.distinct.sum(:amount)}.sum)}</b>", "Net Proceed"]]
  end
  def expenses
    text "Expenses", style: :bold, size: 10, color: "DB4437"
    table(expenses_data, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 290, 90]) do
        cells.borders = []
        row(0).font_style = :bold
    end
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
    end

     table(expenses_total_data, cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [10, 10, 290, 90]) do
        cells.borders = []
        row(0).font_style = :bold
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
    @expenses_data ||= AccountingModule::Expense.updated_at(@date.beginning_of_day, @date.end_of_day).distinct.map{|a| ["", "", a.name, a.entries.entered_on(from_date: @date, to_date: @date).map{|a| a.debit_amounts.distinct.sum(:amount)}.sum]}
  end
  def expenses_total_data
    [["", "", "<b>TOTAL</b>", "#{AccountingModule::Expense.updated_at(@date.beginning_of_day, @date.end_of_day).map{|a| a.entries.entered_on(from_date: @date, to_date: @date).total}.sum}"]]
  end

  def summary_report
    text "Summary Report", style: :bold, size: 10
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
    [["", "", "Cash Received", "#{price(@employee.cash_on_hand_account.debits_balance(from_date: @date.beginning_of_day - 1.second, to_date: @date.end_of_day, recorder_id: @employee.id))}"]] +
    [["", "", "Cash Disbursed",  "#{price(@employee.cash_on_hand_account.credits_balance(from_date: @date.beginning_of_day - 1.second, to_date: @date.end_of_day, recorder_id: @employee.id))}"]]
  end
  def total_summary_data
    [["", "", "Ending Balance", "#{price(@employee.cash_on_hand_account.balance(from_date: @date.beginning_of_day - 1.second, to_date: @date.end_of_day, recorder_id: @employee.id) + @employee.fund_transfer_total)}"]]
  end

  def summary_of_accounts
    text "Summary of Accounts", style: :bold, size: 10

    table(accounts_data, cell_style: { size: 10, font: "Helvetica"}, column_widths: [20, 80, 210, 90]) do
        cells.borders = []
        row(0).font_style = :bold
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
    @accounts_data ||= AccountingModule::Account.updated_at(@date.beginning_of_day, @date.end_of_day).distinct.order(:code).map{|a| ["", a.code, a.name, a.debits_balance(recorder_id: @employee.id), a.credits_balance(recorder_id: @employee.id)]}
  end


end
