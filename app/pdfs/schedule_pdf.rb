class SchedulePdf < Prawn::Document
  def initialize(schedule, employee, view_context)
    super(margin: 30, page_size: 'A4', page_layout: :portrait)
    @schedule = schedule
    @employee = employee
    @view_context = view_context
    heading
  end

  private

  def heading
    bounding_box [0, 780], width: 100 do
      image Rails.root.join('app/assets/images/kccmc_logo.jpg').to_s, width: 50, height: 50, align: :center
    end
    bounding_box [0, 780], width: 530 do
      text 'Tinoc COMMUNITY MULTIPURPOSE DEVELOPMENT COOPERATIVE', align: :center
      text 'Poblacion, Tinoc, Ifugao', size: 12, align: :center
      move_down 10
      text 'PAYMENT SCHEDULE', style: :bold, align: :center
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
