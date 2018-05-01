module LoansModule
  module Reports
    class LoanReleasesPdf < Prawn::Document
      def initialize(loans, from_date, to_date, view_context)
        super(margin: 40, page_size: "A4", page_layout: :portrait)
        @loans = loans
        @from_date = from_date
        @to_date = to_date
        @view_context = view_context
        heading
        loans_table
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
          text "Loan Releases Report", style: :bold, size: 14
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

      def loans_table
        if @loans.any?
          table(table_data, header: true, cell_style: { size: 9, font: "Helvetica"}) do
            column(1).align = :right
            row(0).font_style = :bold
            row(0).background_color = 'DDDDDD'
          end
        else
          "NO Loan Releases"
        end
      end

    def table_data
      move_down 5
      [["Borrower", "Type of Loan", "Address", "Contact Number", "Date Disbursed", "Loan Amount", "Net Proceed"]] +
      @table_data ||= @loans.map { |e| [e.borrower_name, e.loan_product_name, e.borrower_current_address, e.borrower_contact_number, e.disbursement_date.try(:strftime, ("%B %e, %Y")), price(e.loan_amount), price(e.net_proceed)]} +
      [["", "","", "", "", "#{price(@loans.sum(&:loan_amount))}", "#{price(@loans.sum(&:net_proceed))}"]]
    end
    end
  end
end
