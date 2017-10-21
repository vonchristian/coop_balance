class TellerReportPdf < Prawn::Document
  def initialize(employee, view_context)
    super(margin: 30, page_size: "A4", page_layout: :portrait)
    @employee = employee
    @view_context = view_context
    heading
    loan_releases
    loan_collections
  end
  private
  def heading 
    bounding_box [0, 770], width: 100 do
      image "#{Rails.root}/app/assets/images/logo_kcmdc.jpg", width: 50, height: 50, align: :center
    end 
    bounding_box [0, 770], width: 530 do
      text "KIANGAN COMMUNITY MULTIPURPOSE DEVELOPMENT COOPERATIVE", align: :center
      text "Poblacion, Kiangan, Ifugao", size: 12, align: :center
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
    @table_data ||= @employee.entries.loan_disbursement.map{|a| [a.commercial_document.try(:borrower_name), a.commercial_document.number, a.debit_amounts.sum(&:amount), a.credit_amounts.where(account: @employee.cash_on_hand_account).sum(:amount)]} +
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
    [["MEMBER", "OR #", "AMOUNT"]]
  end
end