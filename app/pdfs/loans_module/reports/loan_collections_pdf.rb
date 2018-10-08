module LoansModule
  module Reports
    class LoanCollectionsPdf < Prawn::Document
      attr_reader :collections, :from_date, :to_date, :cooperative, :view_context
      def initialize(args={})
        super(margin: 30, page_size: "A4", page_layout: :portrait)
        @collections  = args[:collections]
        @from_date    = args[:from_date]
        @to_date      = args[:to_date]
        @cooperative  = args[:cooperative]
        @view_context = args[:view_context]
        heading
        collections_table

      end
      private
      def price(number)
        view_context.number_to_currency(number, :unit => "P ")
      end
      def heading
          bounding_box [300, 770], width: 50 do
            image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 50, height: 50
          end
          bounding_box [360, 770], width: 200 do
              text "#{cooperative.abbreviated_name }", style: :bold, size: 20
              text "#{cooperative.name.try(:upcase)}", size: 8
              text "#{cooperative.address}", size: 8
          end
          bounding_box [0, 770], width: 400 do
            text "LOAN COLLECTIONS REPORT", style: :bold, size: 12
            text "From: #{from_date.strftime("%B %e, %Y")}", style: :bold, size: 10
            text "To: #{to_date.strftime("%B %e, %Y")}", style: :bold, size: 10

          end
          move_down 20
          stroke do
            stroke_color '24292E'
            line_width 1
            stroke_horizontal_rule
            move_down 5
          end
        end

      def collections_table
        if collections.any?
          table(table_data, header: true, cell_style: { size: 9, font: "Helvetica"},column_widths: [100, 100, 100, 50, 100, 80]) do
            column(1).align = :right
            row(0).font_style = :bold
            row(0).background_color = 'DDDDDD'
          end
        else
          "NO Loan Collections"
        end
      end

    def table_data
      move_down 5
      [["Borrower", "Type of Loan",  "Payment Date", "OR Number", "Employee", "Amount"]] +
      table_data ||= collections.uniq.map { |e| [e.commercial_document.try(:name), e.commercial_document.try(:loan_product_name), e.entry_date.strftime("%B %e, %Y"), e.reference_number, e.recorder_name, e.amount] } +
      [["", "", "", "", "", "#{(collections.uniq.map{|a| a.amount}.sum) }"]]
    end
    end
  end
end
