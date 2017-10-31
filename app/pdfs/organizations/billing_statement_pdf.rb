module Organizations
  class BillingStatementPdf < Prawn::Document
    def initialize(organization, members, view_context)
      super(margin: 40, page_size: "A4", page_layout: :portrait)
      @organization = organization
      @members = members
      @view_context = view_context
      heading
      loan_details
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
        text "Billing Statement", style: :bold, size: 14
        move_down 3
        text "Date"
        move_down 3
      end
      move_down 15
      stroke do
        stroke_color '24292E'
        line_width 1
        stroke_horizontal_rule
        move_down 20
      end
    end
    def loan_details
      table(members_data) do
        cells.borders = []
      end
    end
    def members_data
      @members_date ||= @members.map{|a| [a.name]}
    end
  end
end
