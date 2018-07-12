module LoansModule
  module Reports
    class LoanCollectionsPdf < Prawn::Document
      def initialize(collections, from_date, to_date, view_context)
        super(margin: 40, page_size: "A4", page_layout: :portrait)
        @collections = collections
        @from_date = from_date
        @to_date = to_date
        @view_context = view_context
        heading
        collections_table
      end
      private
      def price(number)
        @view_context.number_to_currency(number, :unit => "P ")
      end
      def heading
        bounding_box [300, 760], width: 50 do
          image "#{Rails.root}/app/assets/images/kccmc_logo.jpg", width: 40, height: 40
        end
        bounding_box [350, 760], width: 150 do
            text "KCCMC", style: :bold, size: 22
            text "Poblacion, Tinoc, Ifugao", size: 10
        end
        bounding_box [0, 760], width: 400 do
          text "Loan Collections Report", style: :bold, size: 14
          move_down 5
          text "FROM: #{@from_date.strftime("%B %e, %Y")} To: #{@to_date.strftime("%B %e, %Y")}", size: 10
          move_down 5
        end
        move_down 10
        stroke do
          stroke_color 'CCCCCC'
          line_width 0.2
          stroke_horizontal_rule
          move_down 15
        end
      end

      def collections_table
        if @collections.any?
          table(table_data, header: true, cell_style: { size: 9, font: "Helvetica"}, table_widths: [200,100]) do
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
      @table_data ||= @collections.uniq.map { |e| [e.commercial_document.try(:name), e.commercial_document.try(:loan_product_name), e.entry_date.strftime("%B %e, %Y"), e.reference_number, e.recorder_name, price(e.amount)] } +
      [["", "", "", "", "", "#{price(@collections.uniq.map{|a| a.amount}.sum) }"]]
    end
    end
  end
end
