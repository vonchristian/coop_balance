module LoansModule
  class LoanAmortizationSchedulePdf < Prawn::Document
    def initialize(loan, amortization_schedules, view_context)
      super(margin: 30, page_size: "A4", page_layout: :portrait)
      @loan = loan
      @amortization_schedules = amortization_schedules
      @view_context = view_context
      heading
      amortization_schedule
      borrower_signature
      prepared_by_signature
    end
    private
    def price(number)
      @view_context.number_to_currency(number, :unit => "P ")
    end
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
    def amortization_schedule
      table(amortization_schedule_data, header: true, cell_style: { size: 10, font: "Helvetica"}, column_widths: [100, 100, 100, 100, 120]) do

        row(0).font_style = :bold
        row(0).background_color = 'DDDDDD'
        column(0).align = :right
        column(1).align = :right
        column(2).align = :right

        column(3).align = :right
        column(4).align = :right
      end
    end
    def amortization_schedule_data
      [["DATE", "PRINCIPAL", "INTEREST", "TOTAL", "BALANCE"]] +
      @table_date ||= @amortization_schedules.map{|a| [a.date.strftime("%B %e, %Y"), price(a.principal), price(a.interest), price(a.total_amortization), price(@loan.balance_for(a))] }
    end
    def borrower_signature
      text "#{@loan.borrower.try(:first_and_last_name).try(:upcase)}"
      text "BORROWER"
    end
    def prepared_by_signature
      text "PREPARED BY:"
    end
  end
end
