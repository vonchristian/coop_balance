module LoansModule
  class LoanAmortizationSchedulePdf < Prawn::Document
    def initialize(loan, amortization_schedules, employee, view_context)
      super(margin: 50, page_size: "LEGAL", page_layout: :portrait)
      @loan = loan
      @amortization_schedules = amortization_schedules
      @employee = employee
      @view_context = view_context
      heading
      loan_charges_details
      amortization_schedule
      signatory_details
    end
    private

    def formatted_interest(schedule)
      if schedule.has_prededucted_interest?
        "#{price(schedule.interest)} - PREDEDUCTED"
      else
        price(schedule.interest)
      end
    end

    def interest_amount_for(a)
      if @loan.interest_on_loan_charge.charge_adjustment.present? && @loan.interest_on_loan_charge.charge_adjustment.number_of_payments.present?
        number_of_payments = @loan.interest_on_loan_charge.charge_adjustment.number_of_payments
        if @loan.amortization_schedules.order(date: :asc).first(number_of_payments).include?(a)
          "#{price(a.interest)} - PREDEDUCTED"
        else
          price(a.interest)
        end
      end
    end
    def price(number)
      @view_context.number_to_currency(number, :unit => "P ")
    end
    def heading

    bounding_box [360, 930], width: 200 do
        text "KALANGUYA CULTURAL COMMUNITY", style: :bold, size: 8
        text "MULTIPURPOSE COOPERATIVE", style: :bold, size: 8
        move_down 5
        text "Poblacion, Tinoc, Ifugao", size: 7
    end
    bounding_box [0, 930], width: 400 do
      text "LOAN DISCLOSURE STATEMENT AND AMORTIZATION SCHEDULE", style: :bold, size: 10
      move_down 6

      text "Borrower: #{@loan.borrower_name}", size: 10
    end
    move_down 15
    stroke do
      stroke_color '24292E'
      line_width 1
      stroke_horizontal_rule
      move_down 5
    end
  end
  def loan_charges_details
    table([["Application Date", "#{@loan.application_date.strftime("%B %e, %Y")}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [160, 100]) do
      cells.borders = []
      column(1).align = :right
    end

    table([["Maturity Date", "#{@loan.maturity_date.try(:strftime, ("%B %e, %Y"))}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [160, 100]) do
      cells.borders = []
      column(1).align = :right
    end
    table([["Loan Amount", "#{price(@loan.loan_amount)}"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [160, 100]) do
      cells.borders = []
      column(1).align = :right
    end
    table([["<b>Less Charges</b>"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [160, 100]) do
      cells.borders = []
      column(1).align = :right
    end

    table(loan_charges_data, cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [160, 100]) do
      cells.borders = []
      column(1).align = :right


    end

    table([["<b>NET PROCEED</b>", "<b>#{price @loan.net_proceed}</b>"]], cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [160, 100]) do
      cells.borders = []
      column(1).align = :right

    end
    move_down 5

  end
  def loan_charges_data
    @loan_charges_data ||= @loan.loan_charges.map{|a| [a.name, price(a.charge_amount_with_adjustment)]}
  end
    def amortization_schedule

      table(amortization_schedule_data, header: true, cell_style: { size: 8, font: "Helvetica"}, column_widths: [90, 80, 80, 70, 90, 100]) do

        row(0).font_style = :bold
        column(0).align = :right
        column(1).align = :right
        column(2).align = :right
        column(3).align = :right
        column(4).align = :right


      end
    end
    def amortization_schedule_data
      [["DATE", "PRINCIPAL", "INTEREST", "TOTAL AMORTIZATION", "BALANCE", "NOTES"]] +
      [["", "","", "", "#{price(@loan.loan_amount)}", ""]] +
      @table_date ||= @amortization_schedules.order(date: :asc).map{|a|
        [ a.date.strftime("%B %e, %Y"),
          price(a.principal),
          (formatted_interest(a)),
          price(a.total_amortization),
          price(@loan.balance_for(a)),
          ""
        ] }
    end
    def signatory_details
    move_down 20
      table(signatory, cell_style: { inline_format: true, size: 9, font: "Helvetica"}, column_widths: [120, 10, 120, 10, 120, 10, 120]) do
        cells.borders = []
        row(3).font_style = :bold
     end
   end
   def approver
     User.general_manager.last
   end
   def signatory
    [["PREPARED BY", "", "APPROVED BY", "", "DISBURSED BY", "", "RECEIVED BY"]] +
    [["", ""]] +
    [["", ""]] +
    [["DIPANIO MOCATI JR", "", "AGUSTIN C. CALYA-EN", "", "JOY BALANGUI", "", "#{@loan.borrower.try(:first_and_last_name).try(:upcase)}"]] +
    [["#{@loan.preparer_current_occupation.try(:titleize)}", "", "#{approver.current_occupation.to_s.titleize}", "", "Treasurer", "", "Borrower"]]
  end
  end
end
