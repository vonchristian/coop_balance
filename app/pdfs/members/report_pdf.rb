require 'prawn/qrcode'
module Members
  class ReportPdf < Prawn::Document
    def initialize(member, view_context)
      super(margin: 30, page_size: 'A4', page_layout: :portrait)
      @member = member
      @view_context = view_context
      heading
      investment_details
      loans
    end

    private
    def price(number)
      @view_context.number_to_currency(number, :unit => "P ")
    end
    def heading
      bounding_box [300, 780], width: 60 do
       #image "#{Rails.root}/app/assets/images/kccmc_logo.jpg", width: 50, height: 50
      end
      bounding_box [350, 760], width: 150 do
          text "KCCMC", style: :bold, size: 22
          text "Poblacion, Tinoc, Ifugao", size: 10
      end
      bounding_box [0, 760], width: 400 do
        text "Member's Data Sheet", style: :bold, size: 14
        move_down 5
        text "#{@member.name.try(:upcase)}"
      end
      move_down 10
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
    end
    def investment_details
      text "SHARE CAPITAL", style: :bold
      move_down 5
      @member.share_capitals.each do |share_capital|
        table([["", share_capital.share_capital_product_name.try(:upcase), price(share_capital.balance)]], cell_style: { inline_format: true, size: 10, font: "Helvetica" }, column_widths: [20, 150, 100]) do
          cells.borders = []
        end
      end
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
      text "SAVINGS", style: :bold
      move_down 5
      @member.savings.each do |savings_account|
        table([["", savings_account.saving_product_name.try(:upcase), price(savings_account.balance)]], cell_style: { inline_format: true, size: 10, font: "Helvetica" }, column_widths: [20, 150, 100]) do
          cells.borders = []
        end
      end
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
      text "TIME DEPOSITS", style: :bold
      move_down 5
      @member.time_deposits.each do |time_deposit|
        table([["", time_deposit.time_deposit_product_name.try(:upcase), price(time_deposit.balance)]], cell_style: { inline_format: true, size: 10, font: "Helvetica" }, column_widths: [20, 150, 100]) do
          cells.borders = []
        end
      end
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
    end
    def loans
      text "LOANS", style: :bold
      @member.loans.each do |loan|
        table([["", loan.loan_product_name.try(:upcase), price(loan.balance)]], cell_style: { inline_format: true, size: 10, font: "Helvetica" }, column_widths: [20, 150, 100]) do
          cells.borders = []
        end
      end
      stroke do
        stroke_color 'CCCCCC'
        line_width 0.2
        stroke_horizontal_rule
        move_down 15
      end
    end

  end
end
