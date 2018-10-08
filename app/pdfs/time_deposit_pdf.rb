class TimeDepositPdf < Prawn::Document
  attr_reader :time_deposit, :cooperative
  def initialize(time_deposit, view_context)
    super(margin: [40, 80, 40, 80], page_size: [599, 792], page_layout: :landscape)
    # width = 632 width less margin

    @time_deposit = time_deposit
    @cooperative = @time_deposit.cooperative
    heading
    info
    policy
    signatories
  end
  def heading
    bounding_box([0,500], :width => 100, :height => 100) do
      image "#{Rails.root}/app/assets/images/ipsmpc_logo.jpg", width: 100, height: 100
    end
    bounding_box([100,500], :width => 432, :height => 100) do
        text "#{cooperative.name.upcase}", size: 14, align: :center
        text "#{cooperative.address}", size: 12, align: :center
        text "CIN No. #{cooperative.registration_number}", size: 12, align: :center
        move_down 20
        text "CERTIFICATE OF TIME DEPOSIT", style: :bold, size: 18, align: :center
    end
    bounding_box([532,500], width: 100, :height => 100) do
      
    end
  end
  def info
    bounding_box([50,380], :width => 372, :height => 50) do
      text "Due Date:  ", size: 12
      text "Rate    :  ", size: 12
    end
    bounding_box([422,380], :width => 160, :height => 50) do
      text "Amount  :  ", size: 12
      text "Date    :  #{time_deposit.date_deposited.strftime('%B %e, %Y')}", size: 12
    end
  end

  def content
    
  end
  def policy
    text "Policy"
  end
  def signatories
    text "#{time_deposit.depositor.try(:first_and_last_name).try(:upcase)}"
    text "DEPOSITOR"
  end
end

