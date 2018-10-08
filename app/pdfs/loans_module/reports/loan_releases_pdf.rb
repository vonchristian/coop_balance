module LoansModule
  module Reports
    class LoanReleasesPdf < Prawn::Document
      attr_reader :loans, :from_date, :to_date, :cooperative, :organization, :view_context
      def initialize(args={})
        super(margin: 40, page_size: "A4", page_layout: :portrait)
        @loans        = args[:loans]
        @from_date    = args[:from_date]
        @to_date      = args[:to_date]
        @cooperative  = args[:cooperative]
        @organization = args[:organization]
        @view_context = args[:view_context]
        heading
        loans_table
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
            text "LOAN DISBURSEMENTS REPORT", style: :bold, size: 12
            text "From: #{from_date.strftime("%B %e, %Y")}", style: :bold, size: 10
            text "To: #{to_date.strftime("%B %e, %Y")}", style: :bold, size: 10
            text "Organization: #{organization.name.try(:upcase)}", size: 10

          end
          move_down 20
          stroke do
            stroke_color '24292E'
            line_width 1
            stroke_horizontal_rule
            move_down 5
          end
        end

      def loans_table
        if loans.any?
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
      [["Borrower", "Type of Loan", "Organization", "Date Disbursed", "Loan Amount", "Net Proceed"]] +
      @table_data ||= loans.map { |e| [e.borrower_name, e.loan_product_name, e.organization_name, e.disbursement_date.try(:strftime, ("%B %e, %Y")), price(e.loan_amount), price(e.net_proceed)]} +
      [["", "","", "#{price(loans.sum(&:loan_amount))}", "#{price(loans.sum(&:net_proceed))}"]]
    end
    end
  end
end
