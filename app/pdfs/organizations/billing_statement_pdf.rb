module Organizations
  class BillingStatementPdf < Prawn::Document
    def initialize(organization, loans, cooperative, date, view_context)
      super(margin: 20, page_size: "A4", page_layout: :landscape)
      @organization = organization
      @loans = loans
      @cooperative = cooperative
      @date = date
      @view_context = view_context
      heading
      loan_details
    end
    def heading
      bounding_box [550, 550], width: 50 do
        # image "##{@cooperative.logo.path(:small)}", width: 50, height: 50
      end
      bounding_box [610, 550], width: 200 do
          text "#{@cooperative.abbreviated_name}", style: :bold, size: 24
          text "#{@cooperative.name }", size: 10
      end
      bounding_box [0, 550], width: 400 do
        text "BILLING STATEMENT FOR THE MONTH OF #{@date.strftime("%B, %Y").upcase}", style: :bold, size: 10
        move_down 3
        text "#{@organization.name}"
        move_down 3
      end
      move_down 30
      stroke do
        stroke_color '24292E'
        line_width 1
        stroke_horizontal_rule
        move_down 20
      end
    end
    def loan_details
      table(loans_table, header: true, cell_style: { size: 8, font: "Helvetica"}) do
        cells.borders = []
        row(0).size = 8
      end
    end
    def loans_table
      [["BORROWER", "RELEASE DATE", "MATURITY", "LOAN AMOUNT", "LOAN BALANCE", "PRINCIPAL", "INTEREST", "ARREARS", "TOTAL DEDUCTION"]] +
      @loans_table ||= @loans.map{ |a| [a.borrower_name, a.disbursement_date.strftime("%B %e, %Y"), a.maturity_date.strftime("%B %e, %Y")] }
    end
  end
end
