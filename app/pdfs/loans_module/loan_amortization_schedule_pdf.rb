
module LoansModule
  class LoanAmortizationSchedulePdf < Prawn::Document
    attr_reader :loan, :amortization_schedules, :employee, :view_context, :voucher, :cooperative
    def initialize(args)
      super(margin: 40, page_size: "LEGAL", page_layout: :portrait)
      @loan = args[:loan]
      @voucher = @loan.voucher
      @amortization_schedules = args[:amortization_schedules]
      @employee = args[:employee]
      @cooperative = @employee.cooperative
      @view_context = args[:view_context]
      heading
      loan_details
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
      if loan.interest_on_loan_charge.charge_adjustment.present? && loan.interest_on_loan_charge.charge_adjustment.number_of_payments.present?
        number_of_payments = loan.interest_on_loan_charge.charge_adjustment.number_of_payments
        if loan.amortization_schedules.order(date: :asc).first(number_of_payments).include?(a)
          "#{price(a.interest)} - PREDEDUCTED"
        else
          price(a.interest)
        end
      end
    end
    def price(number)
      view_context.number_to_currency(number, :unit => "P ")
    end
    def heading
    bounding_box [320, 930], width: 200 do
        text "#{cooperative.name.try(:upcase)}", style: :bold, size: 12

        move_down 3
        text "#{cooperative.address}", size: 8
        move_down 3
        text "#{cooperative.contact_number}", size: 8
    end
    bounding_box [0, 930], width: 200 do
      text "LOAN DISCLOSURE STATEMENT AND AMORTIZATION SCHEDULE", style: :bold, size: 10
      move_down 6
      text "BORROWER: #{loan.borrower_name.try(:upcase)}", size: 10
    end
    move_down 15
    stroke do
      stroke_color '24292E'
      line_width 1
      stroke_horizontal_rule
      move_down 1
    end
  end
  def loan_details
    bounding_box [0, 865], width: 450 do
      text "LOAN DETAILS", size: 9, style: :bold
      table([["Loan Product", "#{loan.loan_product_name}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 10, font: "Helvetica"}, column_widths: [120, 100]) do
        cells.borders = []
      end
      table([["Loan Amount ", "#{price(loan.loan_amount)}"]], cell_style: { padding: [0,0,0,0],inline_format: true, size: 10, font: "Helvetica"}, column_widths: [120, 200]) do
        cells.borders = []
      end
      table([["Loan Amount (in words)", "#{loan.loan_amount.to_f.to_words.titleize} Pesos"]], cell_style: { padding: [0,0,0,0],inline_format: true, size: 10, font: "Helvetica"}, column_widths: [120, 200]) do
        cells.borders = []
      end
      table([["Term ", "#{loan.current_term.term} Months"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 10, font: "Helvetica"}, column_widths: [120, 300]) do
        cells.borders = []
      end
      table([["Disbursement Date ", "#{loan.disbursement_date.strftime("%B %e, %Y")}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 10, font: "Helvetica"}, column_widths: [120, 300]) do
        cells.borders = []
      end
      table([["Maturity Date ", "#{loan.loan_amount.to_f.to_words.titleize} Pesos"]], cell_style: { padding: [0,0,0,0], inline_format: true, size: 10, font: "Helvetica"}, column_widths: [120, 300]) do
        cells.borders = []
      end
    end
  end
  def loan_charges_details
    bounding_box [300, 865], width: 500 do
      text "LOAN CHARGES DETAILS", style: :bold, size: 9

      table(loan_charges_data, cell_style: {padding: [0,0,0,0], inline_format: true, size: 10, font: "Helvetica"}, column_widths: [120, 100]) do
        cells.borders = []
        column(1).align = :right
      end
    end
  end
  def loan_charges_data
    @loan_charges_data ||= loan.voucher_amounts.order(created_at: :desc).map{|a| [a.description, price(a.adjusted_amount)]}
  end

    def amortization_schedule
      move_down 20
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
      text "AMORTIZATION SCHEDULE", size: 9, style: :bold
      if loan.forwarded_loan? || loan.amortization_schedules.blank?
        text "No data Available"
      else
        table(amortization_schedule_data, header: true, cell_style: { size: 8, font: "Helvetica"}, column_widths: [90, 80, 80, 70, 90, 120]) do

          row(0).font_style = :bold
          column(0).align = :right
          column(1).align = :right
          column(2).align = :right
          column(3).align = :right
          column(4).align = :right


        end
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
    [["#{loan.preparer_first_and_last_name}", "", "AGUSTIN C. CALYA-EN", "", "JOY BALANGUI", "", "#{@loan.borrower.try(:first_and_last_name).try(:upcase)}"]] +
    [["#{@loan.preparer_current_occupation.try(:titleize)}", "", "#{approver.current_occupation.to_s.titleize}", "", "Treasurer", "", "Borrower"]]
  end
  end
end
