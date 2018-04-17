module AccountingModule
  module Reports
    class ProofsheetPdf < Prawn::Document
      def initialize(from_date, to_date, accounts, view_context)
        super(margin: 40, page_size: "A4", page_layout: :portrait)
        @from_date = from_date
        @to_date = to_date
        @accounts = accounts
        @view_context = view_context
        heading
        accounts_table
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
          text "Consolidated Proofsheet Report", style: :bold, size: 14
          move_down 5
          text "#{@to_date.strftime("%B %e, %Y")} ", size: 10
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
      def accounts_table
        table(accounts_data, cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [100, 20, 280, 100]) do
          cells.borders =[]
          column(0).align = :right
          column(3).align = :right
        end
        stroke do
          move_down 5
          stroke_color 'CCCCCC'
          line_width 1
          stroke_horizontal_rule
          move_down 5
        end
        table([["#{price(@accounts.updated_at(from_date: @from_date, to_date: @to_date).map{|a| a.credits_balance}.sum )}", "", "", "#{price(@accounts.map{|a| a.debits_balance}.sum )}"]], cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [100, 20, 280, 100])do
          cells.borders =[]
          column(0).align = :right
          column(3).align = :right
          row(-1).font_style = :bold
        end
      end
      def accounts_data
        [["CREDITS", "", "ACCOUNT TITLE", "DEBITS"]] +
        @accounts_data ||= @accounts.updated_at(from_date: @from_date, to_date: @to_date).map{|a| [price(a.credits_balance(to_date: @to_date)), "", a.name, price(a.debits_balance(to_date: @to_date))] }
      end
    end
  end
end
