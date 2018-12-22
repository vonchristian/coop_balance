class TimeDepositPdf < Prawn::Document
  attr_reader :time_deposit, :cooperative
  def initialize(time_deposit, view_context)
    super(margin: [40, 80, 40, 80], page_size: [599, 792], page_layout: :landscape)
    # width = 632 width less margin
    @view_context = view_context
    @time_deposit = time_deposit
    @cooperative = @time_deposit.cooperative
    heading
    details
    body
    beneficiaries_and_policy
    signatories
  end

  def price(number)
    @view_context.number_to_currency(number, :unit => "P ")
  end

  def heading
    bounding_box([0,500], :width => 100, :height => 100) do
      image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 80, height: 80
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

  def details
    date_of_deposit = time_deposit.terms.last.effectivity_date.strftime('%B %e, %Y')
    maturity_date = time_deposit.maturity_date.strftime('%B %e, %Y')
    amount_of_deposit = price(time_deposit.balance)

    details_left ||=  [["Due Date", ":", maturity_date]] + 
                      [["Rate", ":", "#{interest_rate}% per annum"]]
    details_right ||= [["Amount", ":", amount_of_deposit]] + 
                      [["Date", ":", date_of_deposit]]
    bounding_box([50,380], :width => 342, :height => 60) do
      # stroke_bounds
      table(details_left, cell_style: { 
        :padding => [2,0,0,2], 
        size: 13, font: "Helvetica", 
        inline_format: true }, 
        column_widths: [60, 10, 190] ) do
        cells.borders = []
        column(2).font_style = :bold
      end
    end
    bounding_box([402,380], :width => 190, :height => 60) do
      # stroke_bounds
      table(details_right, cell_style: { 
        :padding => [2,0,0,2], 
        size: 13, font: "Helvetica", 
        inline_format: true }, 
        column_widths: [50, 10, 130] ) do
        cells.borders = []
        column(2).font_style = :bold
      end
    end
  end

  def body
    bounding_box([50,310], :width => 532, :height => 90) do
      # stroke_bounds
      text content, size: 14, align: :justify, inline_format: true
    end
  end

  def beneficiaries_and_policy
    beneficiaries_data ||=  [["", time_deposit.beneficiaries]]
    bounding_box([50,220], :width => 312, :height => 80) do
      # stroke_bounds
      text "Beneficiary/ies :", size: 13
      table(beneficiaries_data, cell_style: { 
        :padding => [2,0,0,2], 
        size: 13, font: "Helvetica", 
        inline_format: true }, 
        column_widths: [50, 200] ) do
        cells.borders = []
      end
    end
    bounding_box([362,220], :width => 220, :height => 80) do
      # stroke_bounds
      text policy, size: 13, align: :justify, inline_format: true 
    end
  end

  def signatories
    bounding_box([50,110], :width => 312, :height => 90) do
      # stroke_bounds
      text "No. #{time_deposit.certificate_number}", size: 13
      move_down 60
      text "Authorized Signature: ______________________", size: 13, style: :bold
    end
    bounding_box([362,110], :width => 220, :height => 90) do
      # stroke_bounds
      text general_manager, size: 13, align: :center, inline_format: true 
      text role, size: 12, align: :center
    end
  end

  def general_manager
    "<b><u>#{cooperative.users.general_manager.last.first_middle_and_last_name.upcase}</u></b>"
  end

  def role
    "#{cooperative.users.general_manager.last.role.titleize}"
  end

  def interest_rate
    (time_deposit.time_deposit_product.interest_rate.to_f * 100).to_i
  end

  def depositor_name_title
    time_deposit.depositor.sex == "male" ? "Mr." : "Ms." if time_deposit.depositor.sex.present?
  end

  def depositor_name
    time_deposit.depositor.try(:first_and_last_name).try(:titleize)
  end

  def amount_in_words
    time_deposit.balance.to_f.to_words.titleize + " Pesos" + " (#{price(time_deposit.balance)})"
  end

  def terms_in_days
    time_deposit.time_deposit_product.number_of_days.to_s + " days"
  end

  def content
    "This is to certify that <b><u><font size='16'>#{depositor_name_title} #{depositor_name}</font></u></b> has deposited in this cooperative the sum of <b><u>#{amount_in_words}</u></b> repayable to him <b><u>#{terms_in_days}</u></b> after date upon return of this Certificate properly endorsed."
  end

  def policy
    "Note: Due date that falls on an non-working day/s shall be withdrawn on the first office day after the due date."
  end

end

