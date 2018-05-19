module LoansModule
  class AmortizationSchedulePdf < Prawn::Document
    def initialize(schedule, view_context)
      super(margin: 30, page_size: "A4", page_layout: :portrait)
      @schedule = schedule
      @view_context = view_context
      heading
    end
    private
    def price(number)
      @view_context.number_to_currency(number, :unit => "P ")
    end
   def heading
    bounding_box [0, 770], width: 100 do
        image "#{Rails.root}/app/assets/images/kccmc_logo.jpg", width: 50, height: 50, align: :center
      end
      bounding_box [0, 770], width: 530 do
        text "KALANGUYA COMMUNITY MULTIPURPOSE DEVELOPMENT COOPERATIVE", align: :center
        text "Poblacion, Tinoc, Ifugao", size: 12, align: :center
        move_down 10
        text "PAYMENT SCHEDULE", style: :bold, align: :center
        move_down 5
        stroke do
          stroke_color 'CCCCCC'
          line_width 0.2
          stroke_horizontal_rule
          move_down 15
        end
      end
  end

  end
end
