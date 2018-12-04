module AccountingModule
  module Reports
    class ProofsheetPdf < Prawn::Document
      attr_reader :to_date, :accounts, :view_context, :employee, :cooperative
      def initialize(args)
        super(margin: 40, page_size: "A4", page_layout: :portrait)
        @to_date      = args[:to_date]
        @accounts     = args[:accounts]
        @employee     = args[:employee]
        @view_context = args[:view_context]
        @cooperative  = @employee.cooperative
        heading
        accounts_table
      end

      private
      def price(number)
        view_context.number_to_currency(number, :unit => "P ")
      end

      def heading
        bounding_box [300, 760], width: 50 do
          image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 40, height: 40
        end
        bounding_box [350, 760], width: 150 do
            text "#{cooperative.abbreviated_name.upcase}", style: :bold, size: 22
            text "#{cooperative.address}", size: 10
        end
        bounding_box [0, 760], width: 400 do
          text "Consolidated Proofsheet Report", style: :bold, size: 14
          move_down 5
          text "#{to_date.strftime("%B %e, %Y")} ", size: 10
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
          row(0).font_style = :bold

        end
        stroke do
          move_down 5
          stroke_color 'CCCCCC'
          line_width 1
          stroke_horizontal_rule
          move_down 5
        end
        table([["#{price(accounts.credits_balance(to_date: to_date) )}", "", "", "#{price(accounts.debits_balance(to_date: to_date) )}"]], cell_style: { inline_format: true, size: 11, font: "Helvetica", :padding => [2,5,2,5]}, column_widths: [100, 20, 280, 100])do
          cells.borders =[]
          column(0).align = :right
          column(3).align = :right
          row(-1).font_style = :bold
        end
      end
      def accounts_data
        [["CREDITS", "", "ACCOUNT TITLE", "DEBITS"]] +
        @accounts_data ||= accounts.map{|a| [price(a.credits_balance(to_date: to_date)), "", a.name, price(a.debits_balance(to_date: to_date))] }
      end
    end
  end
end
