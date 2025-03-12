module LoansModule
  module Notices
    class FirstNoticePdf < Prawn::Document
      def initialize(loan, view_context)
        super(margin: 50, page_size: "LEGAL", page_layout: :portrait)
        @loan = loan
        @view_context = view_context
        heading
        notice_date
        greeter
        content
      end

      private

      def heading
        bounding_box [ 300, 930 ], width: 50 do
          image Rails.root.join("app/assets/images/kccmc_logo.jpg").to_s, width: 50, height: 50
        end
        bounding_box [ 370, 930 ], width: 200 do
          text "KCCMC", style: :bold, size: 24
          text "Poblacion, Tinoc, Ifugao", size: 10
        end
        bounding_box [ 0, 930 ], width: 400 do
          text "FIRST NOTICE", style: :bold, size: 14
          move_down 3
          move_down 3
          text "Borrower: #{@loan.borrower_name}", size: 10
        end
        move_down 30
        stroke do
          stroke_color "24292E"
          line_width 1
          stroke_horizontal_rule
          move_down 10
        end
      end

      def notice_date
        move_down 20
        text @loan.first_notice_date.strftime("%B %e, %Y").to_s, size: 12
        move_down 20
      end

      def greeter
        text "Dear #{@loan.borrower_first_name},"
        move_down 20
        text "Greetings!"
      end

      def content
        move_down 20
        text ""
      end
    end
  end
end
