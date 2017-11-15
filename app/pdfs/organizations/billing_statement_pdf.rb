module Organizations
  class BillingStatementPdf < Prawn::Document
    def initialize(organization, loans, view_context)
      super(margin: 20, page_size: "A4", page_layout: :portrait)
      @organization = organization
      @loans = loans
      @view_context = view_context
      heading
      loan_details
    end
    def heading
      bounding_box [300, 810], width: 50 do
        image "#{Rails.root}/app/assets/images/logo_kcmdc.jpg", width: 50, height: 50
      end
      bounding_box [370, 810], width: 200 do
          text "KCMDC", style: :bold, size: 24
          text "Kiangan Community Multipurpose Cooperative", size: 10
      end
      bounding_box [0, 790], width: 400 do
        text "BILLING STATEMENT FOR THE MONTH OF", style: :bold, size: 12
        move_down 3
        text "#{@organization.name}"
        move_down 3
      end
      move_down 15
      stroke do
        stroke_color '24292E'
        line_width 1
        stroke_horizontal_rule
        move_down 20
      end
    end
    def loan_details
      table(loans_table) do
        cells.borders = []
        row(0).size = 8
      end
    end
    def loans_table
      [["BORROWER", "RELEASE DATE", "MATURITY", "LOAN AMOUNT", "LOAN BALANCE", "PRINCIPAL", "INTEREST", "ARREARS", "TOTAL DEDUCTION"]] +
      @loans_table ||= @loans.map{ |a| [a.borrower_name, a.disbursement_date.strftime("%B %e, %Y")] }
    end
  end
end
