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
    private
    def price(number)
      @view_context.number_to_currency(number, :unit => "P ")
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
        text "BILLING STATEMENT FOR THE MONTH OF #{@date.to_date.strftime("%B, %Y").upcase}", style: :bold, size: 10
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
      table(loans_table, header: true, cell_style: { size: 10, font: "Helvetica"}) do
        cells.borders = []
        row(0).size = 8
      end
    end
    def loans_table
      [["BORROWER", "RELEASE DATE", "MATURITY", "LOAN AMOUNT", "LOAN BALANCE", "PRINCIPAL", "INTEREST", "ARREARS", "TOTAL DEDUCTION"]] +

      @loans_table ||= @loans.disbursed.map{ |a| [a.borrower_name, a.maturity_date.strftime("%B %e, %Y"), a.maturity_date.strftime("%B %e, %Y"), price(a.loan_amount), price(a.balance), price(a.amortized_principal_for(from_date: @date.to_date.beginning_of_month, to_date: @date.to_date.end_of_month)), price(a.amortized_interest_for(from_date: @date.to_date.beginning_of_month, to_date: @date.to_date.end_of_month)), price(a.arrears(from_date: @date.to_date.beginning_of_month, to_date: @date.to_date.end_of_month)), price(a.total_deductions(from_date: @date.to_date.beginning_of_month, to_date: @date.to_date.end_of_month))] }
    end
  end
end
