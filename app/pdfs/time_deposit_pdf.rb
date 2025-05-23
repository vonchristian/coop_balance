class TimeDepositPdf < Prawn::Document
  attr_reader :time_deposit, :cooperative, :maturity_date, :effectivity_date

  def initialize(time_deposit:, view_context:)
    super(margin: [ 30 ], page_size: "A4", page_layout: :portrait)
    # width = 632 width less margin
    # 595 × 842 pts = 535 x 782
    @view_context      = view_context
    @time_deposit      = time_deposit
    @cooperative       = time_deposit.cooperative
    @effectivity_date  = time_deposit.term_effectivity_date.strftime("%B %e, %Y")
    @maturity_date     = time_deposit.term_maturity_date.strftime("%B %e, %Y")
    heading
    details
    body
    beneficiaries_and_policy
    signatories
    line_separator
    heading_copy
    details_copy
    body_copy
    beneficiaries_and_policy_copy
    signatories_copy
  end

  def price(number)
    @view_context.number_to_currency(number, unit: "P ")
  end

  def heading
    bounding_box([ 0, 782 ], width: 80, height: 90) do
      # stroke_bounds
      image Rails.root.join("app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg").to_s, width: 70, height: 70
    end
    bounding_box([ 80, 782 ], width: 375, height: 90) do
      # stroke_bounds
      text cooperative.name.upcase.to_s, size: 13, align: :center
      text cooperative.address.to_s, size: 11, align: :center
      text "CIN No. #{cooperative.registration_number}", size: 11, align: :center
      move_down 15
      text "CERTIFICATE OF TIME DEPOSIT", style: :bold, size: 16, align: :center
    end
    bounding_box([ 455, 782 ], width: 80, height: 90) do
      # stroke_bounds
    end
  end

  def details
    details_left ||=  [ [ "Due Date", ":", maturity_date ] ] +
                      [ [ "Rate", ":", "#{interest_rate}% per annum" ] ]
    details_right ||= [ [ "Amount", ":", price(time_deposit.deposited_amount) ] ] +
                      [ [ "Date", ":", effectivity_date ] ]
    bounding_box([ 0, 692 ], width: 285, height: 60) do
      # stroke_bounds
      table(details_left, cell_style: {
                            padding: [ 2, 0, 0, 2 ],
                            size: 12, font: "Helvetica",
                            inline_format: true
                          },
                          column_widths: [ 60, 10, 190 ]) do
        cells.borders = []
        column(2).font_style = :bold
      end
    end
    bounding_box([ 345, 692 ], width: 190, height: 60) do
      # stroke_bounds
      table(details_right, cell_style: {
                             padding: [ 2, 0, 0, 2 ],
                             size: 12, font: "Helvetica",
                             inline_format: true
                           },
                           column_widths: [ 50, 10, 130 ]) do
        cells.borders = []
        column(2).font_style = :bold
      end
    end
  end

  def body
    bounding_box([ 0, 632 ], width: 535, height: 65) do
      # stroke_bounds
      text content, size: 12, align: :justify, inline_format: true, indent_paragraphs: 60
    end
  end

  def beneficiaries_and_policy
    beneficiaries_data ||= time_deposit.beneficiaries.split(/\s*,\s*/).map { |b| [ "", b ] } if time_deposit.beneficiaries.present?
    bounding_box([ 0, 567 ], width: 230, height: 80) do
      # stroke_bounds
      text "Beneficiary/ies :", size: 12
      if time_deposit.beneficiaries.present?
        table(beneficiaries_data, cell_style: {
                                    padding: [ 2, 0, 0, 2 ],
                                    size: 12, font: "Helvetica",
                                    inline_format: true
                                  },
                                  column_widths: [ 50, 150 ]) do
          cells.borders = []
        end
      end
    end
    bounding_box([ 330, 567 ], width: 205, height: 80) do
      # stroke_bounds
      text policy, size: 12, align: :justify, inline_format: true
    end
  end

  def signatories
    bounding_box([ 0, 487 ], width: 315, height: 65) do
      # stroke_bounds
      text "No. #{time_deposit.certificate_number}", size: 12
      move_down 30
      text "Authorized Signature: ______________________", size: 11, style: :bold
    end
    bounding_box([ 315, 487 ], width: 220, height: 65) do
      # stroke_bounds
      move_down 20
      text general_manager, size: 12, align: :center, inline_format: true
      text role, size: 11, align: :center
    end
  end

  def line_separator
    bounding_box([ -30, 422 ], width: 595, height: 60) do
      # stroke_bounds
      move_down 30
      stroke do
        stroke_color "000000"
        line_width 1
        stroke_horizontal_rule
      end
    end
  end

  def heading_copy
    bounding_box([ 0, 362 ], width: 80, height: 90) do
      # stroke_bounds
      image Rails.root.join("app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg").to_s, width: 70, height: 70
    end
    bounding_box([ 80, 362 ], width: 375, height: 90) do
      # stroke_bounds
      text cooperative.name.upcase.to_s, size: 13, align: :center
      text cooperative.address.to_s, size: 11, align: :center
      text "CIN No. #{cooperative.registration_number}", size: 11, align: :center
      move_down 15
      text "CERTIFICATE OF TIME DEPOSIT", style: :bold, size: 16, align: :center
    end
    bounding_box([ 455, 362 ], width: 80, height: 90) do
      # stroke_bounds
    end
  end

  def details_copy
    details_left ||=  [ [ "Due Date", ":", @maturity_date ] ] +
                      [ [ "Rate", ":", "#{interest_rate}% per annum" ] ]
    details_right ||= [ [ "Amount", ":", price(time_deposit.deposited_amount) ] ] +
                      [ [ "Date", ":", effectivity_date ] ]
    bounding_box([ 0, 272 ], width: 285, height: 60) do
      # stroke_bounds
      table(details_left, cell_style: {
                            padding: [ 2, 0, 0, 2 ],
                            size: 12, font: "Helvetica",
                            inline_format: true
                          },
                          column_widths: [ 60, 10, 190 ]) do
        cells.borders = []
        column(2).font_style = :bold
      end
    end
    bounding_box([ 345, 272 ], width: 190, height: 60) do
      # stroke_bounds
      table(details_right, cell_style: {
                             padding: [ 2, 0, 0, 2 ],
                             size: 12, font: "Helvetica",
                             inline_format: true
                           },
                           column_widths: [ 50, 10, 130 ]) do
        cells.borders = []
        column(2).font_style = :bold
      end
    end
  end

  def body_copy
    bounding_box([ 0, 212 ], width: 535, height: 65) do
      # stroke_bounds
      text content, size: 12, align: :justify, inline_format: true, indent_paragraphs: 60
    end
  end

  def beneficiaries_and_policy_copy
    beneficiaries_data ||= time_deposit.beneficiaries.split(/\s*,\s*/).map { |b| [ "", b ] } if time_deposit.beneficiaries.present?
    bounding_box([ 0, 147 ], width: 230, height: 80) do
      # stroke_bounds
      text "Beneficiary/ies :", size: 12
      if time_deposit.beneficiaries.present?
        table(beneficiaries_data, cell_style: {
                                    padding: [ 2, 0, 0, 2 ],
                                    size: 12, font: "Helvetica",
                                    inline_format: true
                                  },
                                  column_widths: [ 50, 150 ]) do
          cells.borders = []
        end
      end
    end
    bounding_box([ 330, 147 ], width: 205, height: 80) do
      # stroke_bounds
      text policy, size: 12, align: :justify, inline_format: true
    end
  end

  def signatories_copy
    bounding_box([ 0, 67 ], width: 315, height: 65) do
      # stroke_bounds
      text "No. #{time_deposit.certificate_number}", size: 12
      move_down 30
      text "Authorized Signature: ______________________", size: 11, style: :bold
    end
    bounding_box([ 315, 67 ], width: 220, height: 65) do
      # stroke_bounds
      move_down 20
      text general_manager, size: 12, align: :center, inline_format: true
      text role, size: 11, align: :center
    end
  end

  def general_manager
    "<b><u>#{cooperative.users.general_manager.last.first_middle_and_last_name.upcase}</u></b>"
  end

  def role
    cooperative.users.general_manager.last.role.titleize.to_s
  end

  def interest_rate
    (time_deposit.time_deposit_product.interest_rate.to_f * 100)
  end

  def depositor_pronoun
    return unless time_deposit.depositor.class.name != "Organization"

    if time_deposit.depositor.sex.present?
      time_deposit.depositor.sex == "male" ? "him " : "her "
    else
      "him/her"
    end
  end

  def depositor_name_title
    return unless time_deposit.depositor.class.name != "Organization"
    return if time_deposit.depositor.sex.blank?

    time_deposit.depositor.sex == "male" ? "Mr. " : "Ms. "
  end

  def depositor_name
    if time_deposit.depositor.instance_of?(::Organization)
      time_deposit.depositor.name.try(:titleize)
    else
      time_deposit.depositor.first_middle_and_last_name.titleize
    end
  end

  def article_connector
    return unless time_deposit.depositor.instance_of?(::Organization)

    "the "
  end

  def amount_in_words
    AmountInWords.new(time_deposit.deposited_amount).parse! + " (#{price(time_deposit.deposited_amount)})"
  end

  def terms_in_days
    "#{time_deposit.term.number_of_days} days"
  end

  def content
    "This is to certify that #{article_connector}<b><u><font size='14'>#{depositor_name_title}#{depositor_name}</font></u></b> has deposited in this cooperative the sum of <b><u>#{amount_in_words}</u></b> repayable to #{depositor_pronoun} <b><u>#{terms_in_days}</u></b> after date upon return of this Certificate properly endorsed."
  end

  def policy
    "Note: Due date that falls on an non-working day/s shall be withdrawn on the first office day after the due date."
  end
end
