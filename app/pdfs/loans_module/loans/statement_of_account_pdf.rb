module LoansModule
  module Loans
    class StatementOfAccountPdf < Prawn::Document
      attr_reader :loan, :from_date, :to_date, :cooperative

      def initialize(loan:, from_date:, to_date:, view_context:)
        super(margin: 30, page_size: 'A4', page_layout: :portrait)

        @loan         = loan
        @cooperative  = loan.cooperative
        @from_date    = from_date
        @to_date      = to_date
        @view_context = view_context
        heading
        # entries_table
      end

      private

      def price(number)
        view_context.number_to_currency(number, unit: 'P ')
      end

      def heading
        bounding_box [300, 770], width: 50 do
          image Rails.root.join("app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg").to_s, width: 50, height: 50
        end

        bounding_box [360, 770], width: 170 do
          text cooperative.abbreviated_name.to_s, style: :bold, size: 20
          text cooperative.name.try(:upcase).to_s, size: 8
          text cooperative.address.to_s, size: 8
        end
        bounding_box [0, 770], width: 300 do
          text 'STATEMENT OF ACCOUNT', style: :bold, size: 12
          text loan.borrower_name.to_s, size: 11, style: :bold
        end

        move_down 20

        stroke do
          move_down 5
          stroke_color 'CCCCCC'
          line_width 0.2
          stroke_horizontal_rule
          move_down 15
        end
      end
    end
  end
end