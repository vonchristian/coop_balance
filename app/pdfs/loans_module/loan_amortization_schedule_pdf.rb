
module LoansModule
  class LoanAmortizationSchedulePdf < Prawn::Document
    attr_reader :loan, :amortization_schedules, :employee, :view_context, :voucher, :cooperative, :voucher, :term
    def initialize(args)

      super(margin: 40, page_size: "LEGAL", page_layout: :portrait)

      @loan = args[:loan]
      @voucher = args[:voucher] || @loan.disbursement_voucher
      @amortization_schedules = args[:amortization_schedules]
      @employee = args[:employee],
      @cooperative = @loan.cooperative,
      @term        = args[:term],
      @view_context = args[:view_context]
      heading
      loan_details
      loan_charges_details
      amortization_schedule
      signatory_details
      font Rails.root.join("app/assets/fonts/open_sans_regular.ttf")

    end

    private
    def formatted_interest(schedule)
      if schedule.prededucted_interest?
        "#{price(schedule.interest)} - PREDEDUCTED"
      else
        price(schedule.interest)
      end
    end

    def interest_amount_for(a)

      price(a.interest)


    end
    def price(number)
      view_context.number_to_currency(number, :unit => "P ")
    end

    def heading
      bounding_box [260, 930], width: 50 do
        image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 45, height: 45
      end
      bounding_box [320, 930], width: 200 do
          text "#{cooperative.name.try(:upcase)}", style: :bold, size: 12
          text "#{cooperative.address} . #{cooperative.contact_number}", size: 8
      end
      bounding_box [0, 930], width: 200 do
        text "LOAN DISCLOSURE STATEMENT AND AMORTIZATION SCHEDULE", style: :bold, size: 10
        move_down 6
        text "Borrower: #{@loan.borrower_name.try(:upcase)}", size: 10
      end
      move_down 10
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 1
      end
    end
  def loan_details
    bounding_box [0, 865], width: 400, height: 110 do
      text "LOAN DETAILS", size: 9, style: :bold
      table([["Loan Product", "#{loan.loan_product_name}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 10, font: "Helvetica"}, column_widths: [100, 200]) do
        cells.borders = []
      end
      move_down 3

      table([["Loan Amount ", "#{price(loan.loan_amount)}"]], cell_style: { padding: [0,0,0,0],inline_format: true, size: 10, font: "Helvetica"}, column_widths: [100, 300]) do
        cells.borders = []
      end
      move_down 3

      table([["Loan Amount (in words)", "#{loan.loan_amount.to_f.to_words.titleize} Pesos"]], cell_style: { padding: [0,0,0,0],inline_format: true, size: 10 }, column_widths: [100, 300]) do
        cells.borders = []
      end
      move_down 3

      table([["Term ", "#{term} Month/s"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 10, font: "Helvetica"}, column_widths: [100, 300]) do
        cells.borders = []
      end
      move_down 3

      table([["Disbursement Date ", "#{loan.disbursement_date.strftime("%B %e, %Y")}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 10 }, column_widths: [100, 300]) do
        cells.borders = []
      end
      move_down 3
      table([["Maturity Date ", "#{loan.maturity_date.strftime("%B %e, %Y")}"]], cell_style: { padding: [0,0,0,0], inline_format: true, size: 10 }, column_widths: [100, 300]) do
        cells.borders = []
      end
    end
  end
  def loan_charges_details
    bounding_box [320, 865], width: 220, height: 110 do
      text "LOAN DEDUCTIONS", style: :bold, size: 9
      table(loan_amount_data, cell_style: {padding: [0,0,0,0], inline_format: true, size: 10, font: "Helvetica"}, column_widths: [120, 100]) do
        cells.borders = []
        column(1).align = :right
      end
      move_down 4
      table(loan_charges_data, cell_style: {padding: [0,0,2,0], inline_format: true, size: 10, font: "Helvetica"}, column_widths: [120, 100]) do
        cells.borders = []
        column(1).align = :right
      end
      move_down 4
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 4
      end
      table(loan_net_proceed_data, cell_style: {padding: [0,0,0,0], inline_format: true, size: 10, font: "Helvetica"}, column_widths: [120, 100]) do
        cells.borders = []
        column(1).align = :right
        column(1).font_style = :bold
        column(0).font_style = :bold
      end
    end
  end
  def loan_amount_data
    voucher.voucher_amounts.for_account(account: loan.loan_product_current_account).map{ |a| [a.description, price(a.amount)] }
  end
  def loan_net_proceed_data
    voucher.voucher_amounts.for_account(account: cooperative.cash_accounts).map{ |a| [a.description, price(a.amount)] }
  end
  def loan_charges_data
    @loan_charges_data ||= voucher.voucher_amounts.excluding_account(account: loan.loan_product_current_account).excluding_account(account: cooperative.cash_accounts).map{|a| [a.description, price(a.amount)]}
  end

    def amortization_schedule
      move_down 20
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
      text "LOAN AMORTIZATION SCHEDULE", size: 9, style: :bold
      move_down 10
      if loan.forwarded_loan? || loan.amortization_schedules.blank?
        text "No data Available"
      else
        table(amortization_schedule_data, header: true, cell_style: { size: 10 }, column_widths: [100, 80, 80, 70, 90, 110]) do

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
      [["DATE", "PRINCIPAL", "INTEREST", "TOTAL", "BALANCE", "NOTES"]] +
      [["", "","", "", "#{price(@loan.loans_receivable)}", ""]] +
      @table_date ||= @amortization_schedules.order(date: :asc).map{|a|
        [ a.date.strftime("%B %e, %Y"),
          price(a.principal),
          (formatted_interest(a)),
          price(a.total_amortization),
          price(@loan.principal_balance_for(a)),
          ""
        ] }
    end
    def signatory_details
    move_down 20
      table(signatory, cell_style: { inline_format: true, size: 9, font: "Helvetica"}, column_widths: [120, 10, 120, 10, 120, 10, 140]) do
        cells.borders = []
        row(3).font_style = :bold
     end
   end
   def approver
     User.general_manager.first
   end
   def disburser
     User.teller.last
   end
   def preparer
     @loan.preparer
   end
   def signatory
    [["PREPARED BY", "", "APPROVED BY", "", "DISBURSED BY", "", "RECEIVED BY"]] +
    [["", ""]] +
    [["", ""]] +
    [["#{preparer.first_middle_and_last_name.try(:upcase)}", "",
      approver.first_middle_and_last_name.try(:upcase), "",
      disburser.first_middle_and_last_name.upcase, "",
      "#{@loan.borrower.first_middle_and_last_name.try(:upcase)}"]] +
    [["#{preparer.designation.try(:titleize)}", "",
      "#{approver.designation.try(:titleize) }", "",
      "#{disburser.designation.try(:titleize)}", "",
      "Borrower"]]
  end
  end
end
