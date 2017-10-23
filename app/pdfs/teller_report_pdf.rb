class TellerReportPdf < Prawn::Document
  def initialize(employee, view_context)
    super(margin: 30, page_size: "A4", page_layout: :portrait)
    @employee = employee
    @view_context = view_context
    heading
    loan_releases
    loan_collections
    purchases
    deposits
    withdrawals

  end
  private
  def heading 
    bounding_box [0, 780], width: 100 do
      image "#{@employee.cooperative_logo.path(:large)}", width: 50, height: 50, align: :center
    end 
    bounding_box [0, 780], width: 530 do
      text "#{@employee.cooperative_name.upcase}", align: :center, style: :bold
      text "#{@employee.cooperative_address} | #{@employee.cooperative_contact_number}", size: 12, align: :center
    

      move_down 10
      text "TELLER'S TRANSACTION FOR", style: :bold, align: :center
      move_down 5
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
    end
  end 
  def loan_releases
    text "LOAN RELEASES", style: :bold, size: 11
    table(loan_releases_data) do 
      cells.borders = []
    end 
    stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
    end
  end
  def loan_releases_data
    [["BORROWER", "DV #", "LOAN AMOUNT", "NET PROCEEDS"]] +
    @loan_releases_data ||= @employee.entries.loan_disbursement.map{|a| [a.commercial_document.try(:borrower_name), a.reference_number, a.debit_amounts.sum(&:amount), a.credit_amounts.where(account: @employee.cash_on_hand_account).sum(:amount)]} +
    [["", "", "#{@employee.entries.loan_disbursement.total}", "#{@employee.entries.loan_disbursement.map{|a| a.credit_amounts.where(account: @employee.cash_on_hand_account).sum(:amount)}.sum}"]]
  end

  def loan_collections
    text "LOAN COLLECTIONS", style: :bold, size: 11
    table(loan_collections_data) do 
      cells.borders = []
    end 
    stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
    end
  end
  def loan_collections_data
    [["BORROWER", "DV #", "AMOUNT"]] +
    @loan_collections_data ||= @employee.entries.loan_payment.map{|a| [a.commercial_document.try(:borrower_name), a.reference_number, a.debit_amounts.sum(&:amount), a.credit_amounts.where(account: @employee.cash_on_hand_account).sum(:amount)]} +
    [["", "", "#{@employee.entries.loan_disbursement.total}", "#{@employee.entries.loan_disbursement.map{|a| a.credit_amounts.where(account: @employee.cash_on_hand_account).sum(:amount)}.sum}"]]
  end
  def purchases
    text "PURCHASES", style: :bold, size: 11
    table(purchases_data) do 
      cells.borders = []
    end 
    stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
    end
  end
  def purchases_data 
     [["BORROWER", "DV #", "AMOUNT"]] +
    @purchases_data ||= @employee.entries.supplier_payment.map{|a| [a.commercial_document.try(:name), a.reference_number, a.debit_amounts.sum(&:amount), a.credit_amounts.where(account: @employee.cash_on_hand_account).sum(:amount)]} +
    [["", "", "#{@employee.entries.loan_disbursement.total}", "#{@employee.entries.loan_disbursement.map{|a| a.credit_amounts.where(account: @employee.cash_on_hand_account).sum(:amount)}.sum}"]]
  end
  def deposits
     text "DEPOSITS", style: :bold, size: 11
    table(deposits_data) do 
      cells.borders = []
    end 
    stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
    end
  end
   def deposits_data 
     [["MEMBER", "DV #", "AMOUNT"]] +
    @savings_deposits_data ||= @employee.entries.deposit.map{|a| [a.commercial_document.try(:name), a.reference_number, a.debit_amounts.sum(&:amount), a.credit_amounts.where(account: @employee.cash_on_hand_account).sum(:amount)]} +
    [["", "", "#{@employee.entries.loan_disbursement.total}", "#{@employee.entries.loan_disbursement.map{|a| a.credit_amounts.where(account: @employee.cash_on_hand_account).sum(:amount)}.sum}"]]
  end
  def withdrawals
     text "WITHDRAWALS", style: :bold, size: 11
    table(withdrawals_data) do 
      cells.borders = []
    end 
    stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
    end
  end
   def withdrawals_data 
     [["MEMBER", "DV #", "AMOUNT"]] +
    @savings_deposits_data ||= @employee.entries.withdrawal.map{|a| [a.commercial_document.try(:name), a.reference_number, a.debit_amounts.sum(&:amount), a.credit_amounts.where(account: @employee.cash_on_hand_account).sum(:amount)]} +
    [["", "", "#{@employee.entries.loan_disbursement.total}", "#{@employee.entries.loan_disbursement.map{|a| a.credit_amounts.where(account: @employee.cash_on_hand_account).sum(:amount)}.sum}"]]
  end
end