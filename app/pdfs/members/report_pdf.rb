require "prawn/qrcode"
module Members
  class ReportPdf < Prawn::Document
    attr_reader :member, :view_context, :cooperative

    def initialize(args = {})
      super(margin: 40, page_size: "A4", page_layout: :portrait)
      @member = args[:member]
      @cooperative = args[:cooperative]
      @view_context = args[:view_context]
      heading
      profile
      investment_details
      loans
    end

    private

    def price(number)
      view_context.number_to_currency(number, unit: "P ")
    end

    def heading
      bounding_box [ 300, 770 ], width: 50 do
        image Rails.root.join("app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg").to_s, width: 50, height: 50
      end
      bounding_box [ 360, 770 ], width: 200 do
        text cooperative.abbreviated_name.to_s, style: :bold, size: 20
        text cooperative.name.try(:upcase).to_s, size: 8
        text cooperative.address.to_s, size: 8
      end
      bounding_box [ 0, 770 ], width: 400 do
        text "MEMBER'S DATA SHEET", style: :bold, size: 12
        text "", style: :bold, size: 10
      end
      move_down 40
      stroke do
        stroke_color "24292E"
        line_width 1
        stroke_horizontal_rule
        move_down 5
      end
    end

    def profile
      text "MEMBER'S PROFILE", style: :bold
      table([ [ "", "Member", "<b>#{@member.name.try(:upcase)}</b>" ] ], cell_style: { inline_format: true, size: 10, font: "Helvetica" }, column_widths: [ 20, 150, 200 ]) do
        cells.borders = []
      end
      table([ [ "", "Contact Number", @member.contact_number ] ], cell_style: { inline_format: true, size: 10, font: "Helvetica" }, column_widths: [ 20, 150, 200 ]) do
        cells.borders = []
      end
      table([ [ "", "Address", @member.current_address_complete_address ] ], cell_style: { inline_format: true, size: 10, font: "Helvetica" }, column_widths: [ 20, 150, 200 ]) do
        cells.borders = []
      end
      table([ [ "", "Date of Birth", @member.date_of_birth.try(:strftime, "%B %e, %Y") ] ], cell_style: { inline_format: true, size: 10, font: "Helvetica" }, column_widths: [ 20, 150, 200 ]) do
        cells.borders = []
      end
      table([ [ "", "Organization/Office", @member.current_organization.try(:name) ] ], cell_style: { inline_format: true, size: 10, font: "Helvetica" }, column_widths: [ 20, 150, 200 ]) do
        cells.borders = []
      end
      stroke do
        move_down 5
        stroke_color "CCCCCC"
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
    end

    def investment_details
      text "SHARE CAPITAL", style: :bold
      move_down 5
      table(share_capitals_data, cell_style: { inline_format: true, size: 10, font: "Helvetica" }, column_widths: [ 20, 150, 100 ]) do
        cells.borders = []
        row(0).size = 8
        row(0).font_style = :bold
      end
      stroke do
        stroke_color "CCCCCC"
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
      text "SAVINGS", style: :bold
      move_down 5
      @member.savings.each do |savings_account|
        table([ [ "", savings_account.saving_product_name.try(:upcase), price(savings_account.balance) ] ], cell_style: { inline_format: true, size: 10, font: "Helvetica" }, column_widths: [ 20, 150, 100 ]) do
          cells.borders = []
        end
      end
      stroke do
        stroke_color "CCCCCC"
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
      text "TIME DEPOSITS", style: :bold
      move_down 5
      @member.time_deposits.each do |time_deposit|
        table([ [ "", time_deposit.time_deposit_product_name.try(:upcase), price(time_deposit.balance) ] ], cell_style: { inline_format: true, size: 10, font: "Helvetica" }, column_widths: [ 20, 150, 100 ]) do
          cells.borders = []
        end
      end
      stroke do
        stroke_color "CCCCCC"
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
    end

    def loans
      text "LOANS", style: :bold
      @member.loans.disbursed.not_archived.each do |loan|
        table([ [ "", loan.loan_product_name.try(:upcase), price(loan.balance) ] ], cell_style: { inline_format: true, size: 10, font: "Helvetica" }, column_widths: [ 20, 150, 100 ]) do
          cells.borders = []
        end
      end
      stroke do
        stroke_color "CCCCCC"
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
    end

    def share_capitals_data
      [ [ "", "TYPE", "BALANCE", "NO. OF SHARES" ] ] +
        @share_capitals_data ||= @member.share_capitals.map { |share_capital| [ "", share_capital.share_capital_product_name.try(:upcase), price(share_capital.balance), share_capital.shares ] }
    end
  end
end
