module LoansModule
  class AmortizationSchedulesPdf < Prawn::Document
    attr_reader :from_date, :to_date, :amortization_schedules, :view_context, :cooperative
    def initialize(args)
      super(margin: 20, page_size: "A4", page_layout: :portrait)
      @from_date = args[:from_date]
      @to_date = args[:to_date]
      @amortization_schedules = args[:amortization_schedules]
      @view_context = args[:view_context]
      @cooperative  = args[:cooperative]
      heading
      summary
      schedules_details
      font Rails.root.join("app/assets/fonts/open_sans_light.ttf")
    end
    private
    def price(number)
      view_context.number_to_currency(number, :unit => "P ")
    end
    def heading
      bounding_box [280, 790], width: 50 do
        image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 55, height: 55
      end
      bounding_box [340, 790], width: 200 do
          text "#{cooperative.abbreviated_name }", style: :bold, size: 20
          text "#{cooperative.name.try(:upcase)}", size: 8
          text "#{cooperative.address}", size: 8
      end
      bounding_box [0, 790], width: 400 do
        text "SCHEDULE OF AMORTIZATIONS", style: :bold, size: 12
        move_down 2
        text "Date Covered: #{from_date.strftime("%B %e, %Y")} - #{to_date.strftime("%B %e, %Y")}", size: 10
      end
      move_down 35
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.5
        stroke_horizontal_rule
        move_down 20
      end
    end
    def summary
      text "SUMMARY", size: 10, style: :bold
      table([["# of Amortization", "#{amortization_schedules.count}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 10}, column_widths: [120, 100]) do
        cells.borders = []
        column(1).align = :right
      end
      move_down 2
      table([["TOTAL PRINCIPAL", "#{price amortization_schedules.sum(&:principal)}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 10}, column_widths: [120, 100]) do
        cells.borders = []
        column(1).align = :right

      end
      move_down 2
      table([["TOTAL INTEREST", "#{price amortization_schedules.sum(&:interest)}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 10}, column_widths: [120, 100]) do
        cells.borders = []
        column(1).align = :right

      end
      move_down 2
      table([["TOTAL AMORTIZATION", "#{price amortization_schedules.sum(&:total_amortization)}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 10}, column_widths: [120, 100]) do
        cells.borders = []
        column(1).align = :right

      end

      move_down 10
    end
    def schedules_details
      table(schedules_data, cell_style: { inline_format: true, size: 8, :padding => [2,5,2,5]}, column_widths: [70, 70, 90, 80, 60, 60, 60, 60]) do
        column(6).align = :right
        column(7).align = :right
        column(5).align = :right
        row(0).font_style = :bold
      end
    end
    def schedules_data
      [["DUE DATE", "LOAN", "BORROWER", "ADDRESS", "CONTACT", "PRINCIPAL", "INTEREST", "TOTAL"]] +
      @schedules_data ||= amortization_schedules.map{ |schedule|
      [schedule.date.strftime("%b. %e, %Y"),
      schedule.loan_product_name,
      schedule.borrower_name,
      schedule.borrower_current_address_complete_address,
      schedule.borrower_current_contact_number,
      price(schedule.principal),
      price(schedule.interest),
      price(schedule.total_amortization) ]}
    end
  end
end
