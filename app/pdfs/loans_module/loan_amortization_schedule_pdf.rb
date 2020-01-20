
module LoansModule
  class LoanAmortizationSchedulePdf < Prawn::Document
    attr_reader :loan, :amortization_schedules, :employee, :view_context, :voucher, :cooperative, :voucher, :term
    def initialize(args)

      super(margin: 40, page_size: [612, 936], page_layout: :portrait)

      @loan                   = args[:loan]
      @voucher                = args[:voucher] || @loan.disbursement_voucher
      @amortization_schedules = args[:amortization_schedules]
      @employee               = args[:employee],
      @cooperative            = @loan.cooperative,
      @term                   = @loan.term,
      @view_context           = args[:view_context]
      heading
      summary
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
      bounding_box [260, 870], width: 50 do
        image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 45, height: 45
      end
      bounding_box [320, 870], width: 200 do
          text "#{cooperative.name.try(:upcase)}", style: :bold, size: 12
          text "#{cooperative.address} . #{cooperative.contact_number}", size: 8
      end
      bounding_box [0, 870], width: 200 do
        text "LOAN DISCLOSURE STATEMENT AND AMORTIZATION SCHEDULE", style: :bold, size: 10
        move_down 6
        text "Borrower: #{@loan.borrower_name.try(:upcase)}", size: 10
      end
      move_down 10
      stroke do
        stroke_color '000000'
        line_width 0.2
        stroke_horizontal_rule
        move_down 2
      end
    end

    def summary
      table([[loan_details, loan_charges_details]], cell_style: {padding: [0,0,0,0], size: 9, font: "Helvetica"}, column_widths: [310, 220]) do
        cells.borders = []
      end
    end

    def loan_details
      loan_details_data ||= [[{content: "LOAN DETAILS", size: 9}, ""]] +
                            [["Loan Product", "#{loan.loan_product_name}"]] +
                            [["Loan Amount ", "#{price(loan.loan_amount)}"]] +
                            [["Amount (in words)", "#{loan.loan_amount.to_f.to_words.titleize} Pesos"]] +
                            [["Term ", "#{term} Month/s"]] +
                            [["Disbursement Date ", "#{loan.disbursement_date.strftime("%B %e, %Y")}"]] +
                            [["Maturity Date ", "#{loan.maturity_date.strftime("%B %e, %Y")}"]]

      make_table(loan_details_data, cell_style: { padding: [0,0,1,0], inline_format: true, size: 9 }, column_widths: [100, 210]) do
        row(0).font_style = :bold
        cells.borders = []
      end
    end

    def loan_charges_details
      header = [[{content: "LOAN DEDUCTIONS", size: 9}, ""]]
      loan_amount_data = voucher.voucher_amounts.for_account(account: loan.receivable_account).reverse.map{ |a| [a.description, price(a.amount)] }
      loan_charges_data = voucher.voucher_amounts.excluding_account(account: loan.receivable_account).excluding_account(account: cooperative.cash_accounts).map{|a| [a.description, price(a.amount)]}
      loan_net_proceed_data = voucher.voucher_amounts.for_account(account: cooperative.cash_accounts).map{ |a| [a.description, price(a.amount)] }
      table_data = [*header, *loan_amount_data, *loan_charges_data, *loan_net_proceed_data]

      make_table(table_data, cell_style: {padding: [0,0,1,0], inline_format: true, size: 9, font: "Helvetica"}, column_widths: [140, 80]) do
        cells.borders = []
        row(1).padding = [0,0,2,0]
        row(-1).borders = [:top]
        row(-1).padding = [2,0,0,0]
        row(-2).padding = [0,0,3,0]
        row(0).font_style = :bold
        column(1).align = :right
      end
    end

    def amortization_schedule
      move_down 5
      stroke do
        stroke_color '000000'
        line_width 0.2
        stroke_horizontal_rule
        move_down 5
      end
      text "LOAN AMORTIZATION SCHEDULE", size: 9, style: :bold
      move_down 5
      if loan.forwarded_loan? || loan.amortization_schedules.blank?
        text "No data Available"
      else
        table(amortization_schedule_data, header: true, cell_style: {padding: [1,3,1,3], size: 8.5 }, column_widths: [100, 80, 80, 70, 90, 110]) do

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
      [["", "","", "", "#{price(@loan.loan_amount)}", ""]] +
      @table_date ||= @amortization_schedules.order(date: :asc).map{|a|
        [ a.date.strftime("%B %e, %Y"),
          price(a.principal),
          (formatted_interest(a)),
          price(a.total_repayment),
          price(a.ending_balance),
          ""
        ] }
    end
    def signatory_details
    move_down 20
      table(signatory, cell_style: {padding: [1,0,1,0], inline_format: true, size: 9, font: "Helvetica"}, column_widths: [120, 10, 120, 10, 120, 10, 140]) do
        cells.borders = []
        row(11).font_style = :bold
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
    [["PREPARED BY", "", "APPROVED BY", "", "DISBURSED BY", "", "RECIEVED BY"]] +
    [["", "", "", "", "", "", ""]] +
    [["", "", "", "", "", "", ""]] +
    [["", "", "", "", "", "", ""]] +
    [["", "", "", "", "", "", ""]] +
    [["", "", "", "", "", "", ""]] +
    [["", "", "", "", "", "", ""]] +
    [["", "", "", "", "", "", ""]] +
    [["", "", "", "", "", "", ""]] +
    [["", "", "", "", "", "", ""]] +
    [["", "", "", "", "", "", ""]] +
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
