module LoansModule
  module Reports
    class LoanReleasesPdf < Prawn::Document
      attr_reader :loans, :from_date, :to_date, :cooperative, :organization, :view_context

      def initialize(args = {})
        super(margin: 30, page_size: 'A4', page_layout: :portrait)
        @loans        = args[:loans]
        @from_date    = args[:from_date]
        @to_date      = args[:to_date]
        @cooperative  = args[:cooperative]
        @organization = args[:organization]
        @view_context = args[:view_context]
        @loan_products = @cooperative.loan_products.where(id: @loans.pluck(:loan_product_id)).uniq
        heading
        summary
        loans_table
        font Rails.root.join('app/assets/fonts/open_sans_light.ttf')
      end

      private

      def price(number)
        view_context.number_to_currency(number, unit: 'P ')
      end

      def heading
        bounding_box [280, 770], width: 50 do
          image Rails.root.join("app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg").to_s, width: 55, height: 55
        end
        bounding_box [340, 770], width: 200 do
          text cooperative.abbreviated_name.to_s, style: :bold, size: 20
          text cooperative.name.try(:upcase).to_s, size: 8
          text cooperative.address.to_s, size: 8
        end
        bounding_box [0, 770], width: 400 do
          text 'LOAN RELEASES', style: :bold, size: 12
          move_down 2
          text "Period Covered: #{from_date.strftime('%b. %e, %Y')} - #{to_date.strftime('%b. %e, %Y')}", size: 10
        end
        move_down 35
        stroke do
          stroke_color 'CCCCCC'
          line_width 0.5
          stroke_horizontal_rule
          move_down 20
        end
      end

      def summary
        text 'SUMMARY', size: 10, style: :bold
        move_down 5
        @loan_products.each do |loan_product|
          text loan_product.name, style: :bold, size: 10
          table([['', 'Loan Count', loans.where(loan_product_id: loan_product.id).count.to_s]], cell_style: { padding: [0, 0, 0, 0], inline_format: true, size: 10 }, column_widths: [20, 120, 100]) do
            cells.borders = []
            column(2).align = :right
          end
          table([['', 'Total Amount', price(loans.where(loan_product_id: loan_product.id).sum(&:loan_amount)).to_s]], cell_style: { padding: [0, 0, 0, 0], inline_format: true, size: 10 }, column_widths: [20, 120, 100]) do
            cells.borders = []
            column(2).align = :right
          end
          table([['', 'Total Net Proceed', price(loans.where(loan_product_id: loan_product.id).sum(&:net_proceed)).to_s]], cell_style: { padding: [0, 0, 0, 0], inline_format: true, size: 10 }, column_widths: [20, 120, 100]) do
            cells.borders = []
            column(2).align = :right
          end
          move_down 5
          stroke do
            stroke_color 'CCCCCC'
            line_width 0.5
            stroke_horizontal_rule
            move_down 5
          end
        end
        table([['Loan Count', loans.count.to_s]], cell_style: { padding: [0, 0, 0, 0], inline_format: true, size: 10 }, column_widths: [140, 100]) do
          cells.borders = []
          row(0).font_style = :bold
          column(1).align = :right
        end
        table([['Total Loan Amount', price(loans.sum(&:loan_amount)).to_s]], cell_style: { padding: [0, 0, 0, 0], inline_format: true, size: 10 }, column_widths: [140, 100]) do
          cells.borders = []
          row(0).font_style = :bold
          column(1).align = :right
        end
        table([['Total Net Proceed', price(loans.sum(&:net_proceed)).to_s]], cell_style: { padding: [0, 0, 0, 0], inline_format: true, size: 10 }, column_widths: [140, 100]) do
          cells.borders = []
          row(0).font_style = :bold
          column(1).align = :right
        end
      end

      def loans_table
        move_down 5
        stroke do
          stroke_color 'CCCCCC'
          line_width 0.5
          stroke_horizontal_rule
          move_down 5
        end
        if loans.any?
          table(table_data, header: true, cell_style: { padding: [2, 3, 2, 3], size: 9 }, column_widths: [60, 110, 60, 124, 90, 90]) do
            column(4).align = :right
            column(5).align = :right
            row(0).font_style = :bold
            row(0).background_color = 'DDDDDD'
          end
        else
          'No Loan Releases'
        end
      end

      def table_data
        move_down 5
        [['Date', 'Borrower', 'CDV#', 'Type of Loan', 'Loan Amount', 'Net Proceed']] +
          @table_data ||= loans.sort_by(&:ascending_order).map { |e| [e.accounting_entry.entry_date.try(:strftime, '%D'), e.borrower_name, e.tracking_number, e.loan_product_name, price(e.loan_amount), price(e.net_proceed)] }
      end
    end
  end
end
