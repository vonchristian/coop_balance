module LoansModule
  module Reports
    class FilteredLoansPdf < Prawn::Document
      def initialize(loans, view_context)
        super(margin: 40, page_size: "A4", page_layout: :portrait)
        @loans = loans
        @view_context = view_context
        heading
        loans_table
      end
      private
      def price(number)
        @view_context.number_to_currency(number, :unit => "P ")
      end
      def heading
        bounding_box [300, 780], width: 50 do
          image "#{Rails.root}/app/assets/images/logo_kcmdc.jpg", width: 50, height: 50
        end
        bounding_box [370, 780], width: 200 do
            text "KCMDC", style: :bold, size: 24
            text "Kiangan Community Multipurpose Cooperative", size: 10
        end
        bounding_box [0, 780], width: 400 do
          text "Loans Report", style: :bold, size: 14
          move_down 3
          text "#{Date.today.strftime("%B %e, %Y")}", size: 10
          text "#{@loans.count}"
          move_down 3

          # text "Employee: #{@employee.name}", size: 10
        end
        move_down 15
        stroke do
          stroke_color '24292E'
          line_width 1
          stroke_horizontal_rule
          move_down 20
        end
      end
       def loans_table
      table(table_data, header: true, cell_style: { size: 12, font: "Helvetica"}) do
        column(1).align = :right
        row(0).font_style = :bold
        row(0).background_color = 'DDDDDD'
      end
    end

    def table_data
      move_down 5
      [["Borrower", "Date Disbursed", "Net Proceed", "Balance"]] +
      @table_data ||= @loans.map { |e| [e.borrower_name, e.disbursement_date.try(:strftime, ("%B %e, %Y")), price(e.net_proceed), price(e.balance)]} +
      [["#{@loans.count}", "#{price(@loans.sum(&:balance))}"]]
    end
    end
  end
end
