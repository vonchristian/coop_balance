module LoansModule
  class LoanAmortizationSchedulePdf < Prawn::Document
    def initialize(loan, amortization_schedules, employee, view_context)
      super(margin: 30, page_size: "A4", page_layout: :portrait)
      @loan = loan
      @amortization_schedules = amortization_schedules
      @employee = employee
      @view_context = view_context
      heading
      amortization_schedule
      borrower_signature
      prepared_by_signature
      approved_by_signature
    end
    private
    def other_charges_for(date)
      charges = []
      @loan.loan_charge_payment_schedules.scheduled_for(date).each do |a|
        charges << a.name_and_amount
      end
      charges.join("")
    end
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
      text "AMORTIZATION SCHEDULE", style: :bold, size: 14
      move_down 3

      move_down 3

      text "Borrower: #{@loan.borrower_name}", size: 10
    end
    move_down 30
    stroke do
      stroke_color '24292E'
      line_width 1
      stroke_horizontal_rule
      move_down 20
    end
  end
    def amortization_schedule
      table(amortization_schedule_data, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 90, 90, 90, 70, 90]) do

        row(0).font_style = :bold
        row(0).background_color = 'DDDDDD'
        column(0).align = :right
        column(1).align = :right
        column(2).align = :right

        column(3).align = :right
        column(4).align = :right
        column(3).size = 8

        column(5).align = :right

      end
    end
    def amortization_schedule_data
      [["DATE", "PRINCIPAL", "INTEREST", "OTHER CHARGES", "TOTAL", "BALANCE"]] +
      @table_date ||= @amortization_schedules.order(date: :asc).map{|a| [a.date.strftime("%B %e, %Y"), price(a.principal), price(a.interest), other_charges_for(a.date), price(a.total_amortization), price(@loan.balance_for(a))] }
    end
    def borrower_signature
      text "#{@loan.borrower.try(:first_and_last_name).try(:upcase)}"
      text "BORROWER"
      move_down 15
      text "#{@loan.borrower_name.upcase}", style: :bold
    end
    def prepared_by_signature
      text "PREPARED BY:"
      move_down 15
      text "#{@employee.first_and_last_name.upcase}", style: :bold
    end
    def approved_by_signature
      text "APPROVED BY"
      move_down 15

      text "#{@employee.first_and_last_name.upcase}", style: :bold
    end
  end
end
