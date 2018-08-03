class TimeDepositPdf < Prawn::Document
  attr_reader :time_deposit
  def initialize(time_deposit, view_context)
    super(margin: 40, page_size: "A4", page_layout: :portrait)
    @time_deposit = time_deposit
    heading
    policy
    signatories
  end
  def heading
    bounding_box [300, 780], width: 50 do
      image "#{Rails.root}/app/assets/images/kccmc_logo.jpg", width: 150, height: 150
    end
    bounding_box [370, 780], width: 200 do
        text "KCCMC", style: :bold, size: 24
        text "Tinoc Community Multipurpose Cooperative", size: 10
    end
    bounding_box [0, 780], width: 400 do
      text "TIME DEPOSIT CERTIFICATE", style: :bold, size: 12
      move_down 30

      move_down 5
    end
    stroke do
      stroke_color '24292E'
      line_width 1
      stroke_horizontal_rule
      move_down 10
    end
  end
  def policy
    text "Policy"
  end
  def signatories
    text "#{time_deposit.depositor.try(:first_and_last_name).try(:upcase)}"
    text "DEPOSITOR"
  end
end

