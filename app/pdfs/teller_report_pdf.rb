class TellerReportPdf < Prawn::Document
  def initialize(employee, view_context)
    super(margin: 40, page_size: "A4", page_layout: :portrait)
    @employee = employee
    @view_context = view_context
    heading
    fund_transfers
    savings_deposits
    time_deposits
    share_capitals
    loan_releases

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
      text "Teller's Transaction", style: :bold, size: 10
      move_down 5
      text "#{Time.zone.now.strftime("%B %e, %Y")}", size: 10
    end
    move_down 30
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
    end
  end
  def fund_transfers
    text "Fund Transfers",  color: "4A86CF", style: :bold, size: 10
    table([["", "Fund Transfer from Treasury", "#{price(100)}"]], header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 300, 100]) do
      cells.borders = []
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
      table(savings_deposits_balances, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 300, 100]) do
      cells.borders = []
      end
      table(savings_deposits_from_members, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 290, 90]) do
      cells.borders = []
      row(0).text_color = "008751"
      end
      table(withdrawals_from_members, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 290, 90]) do
        cells.borders = []
        row(0).text_color = "DB4437"
      end
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.1
        stroke_horizontal_rule
    end
      table(total_savings_deposits, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 290, 90]) do
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
  #Savings Deposits
  def savings_deposits_balances
    [["", "Beginning Balance", "#{price(100)}"]]
  end
  def savings_deposits_from_members
    [["", "", "Add Deposits", "#{price(100)}"]]
  end
  def total_savings_deposits
    [["", "", "Total Savings Deposits", "900"]]
  end
  def withdrawals_from_members
    [["", "", "Less Withdrawals", "#{price(100)}"]]
  end
  def time_deposits
    text "Time Deposits", style: :bold, size: 10, color: "4A86CF"
  table(time_deposits_balances, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 300, 100]) do
      cells.borders = []
      end
      table(time_deposits_from_members, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 290, 90]) do
      cells.borders = []
      row(0).text_color = "008751"
      end
      table(time_deposit_withdrawals_from_members, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 290, 90]) do
        cells.borders = []
        row(0).text_color = "DB4437"
      end
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.1
        stroke_horizontal_rule
    end
      table(total_time_deposits, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 290, 90]) do
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
  def time_deposits_balances
    [["", "Beginning Balance", "#{price(100)}"]]
  end
  def time_deposits_from_members
    [["", "", "Add Time Deposits", "#{price(100)}"]]
  end
  def total_time_deposits
    [["", "", "Total Time Deposits", "900"]]
  end
  def time_deposit_withdrawals_from_members
    [["", "", "Less Deposit Withdrawals", "#{price(100)}"]]
  end
  def share_capitals
    text "Share Capitals", style: :bold, size: 10, color: "4A86CF"
    table(share_capital_beginning_balance, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 300, 100]) do
      cells.borders = []
    end
      table(additional_share_capital, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 290, 90]) do
      cells.borders = []
      row(0).text_color = "008751"
      end
      table(share_capital_withdrawals, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 290, 90]) do
        cells.borders = []
        row(0).text_color = "DB4437"
      end
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.1
        stroke_horizontal_rule
    end
      table(total_share_capitals, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [10, 10, 290, 90]) do
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
  def share_capital_beginning_balance
    [["", "Beginning Balance", "#{price(100)}"]]
  end
  def additional_share_capital
    [["", "", "Add Share Capital", "#{price(100)}"]]
  end
  def total_share_capitals
    [["", "", "Total Share Capitals", "900"]]
  end
  def share_capital_withdrawals
    [["", "", "Less Share Capital", "#{price(100)}"]]
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
    @loan_releases_data ||= @employee.entries.loan_disbursement.map{|a| [ {image: a.commercial_document.borrower.avatar.path(:medium), image_height: 30, image_width: 30 }, a.commercial_document.try(:borrower_name), a.reference_number, price(a.commercial_document.loan_amount), price(a.commercial_document.net_proceed)]}
  end

  def loan_releases_total
    [["", "Borrower", "Voucher #", "<b>#{price(@employee.entries.loan_disbursement.map{|a| a.debit_amounts.distinct.sum(:amount)}.sum)}</b>", "Net Proceed"]]
  end

end
