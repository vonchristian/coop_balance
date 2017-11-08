module LoansModule
  module Reports
    class LoanProtectionFundPdf < Prawn::Document
      def initialize(loan_protection_funds)
        super(margin: 40, page_size: "A4", page_layout: :portrait)
        @loan_protection_funds = loan_protection_funds
        heading
      end
      def heading
        bounding_box [300, 780], width: 50 do
          image "#{Rails.root}/app/assets/images/logo_kcmdc.jpg", width: 50, height: 50
        end
        bounding_box [370, 780], width: 200 do
          text "KCMDC", style: :bold, size: 24
          text "Kiangan Community Multipurpose Cooperative", size: 10
          move_down 10
        end
        bounding_box [0, 780], width: 400 do
          text "Loan Protection Funds", style: :bold, size: 14
          move_down 12
        end
        move_down 30
        stroke do
          stroke_color '24292E'
          line_width 1
          stroke_horizontal_rule
          move_down 20
        end
      end
    end
  end
end
