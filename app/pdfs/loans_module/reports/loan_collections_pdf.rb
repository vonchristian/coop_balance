module LoansModule
  module Reports
    class LoanCollectionsPdf < Prawn::Document
      attr_reader :collections, :from_date, :to_date, :cooperative, :organization, :view_context
      def initialize(args={})
        super(margin: 30, page_size: "A4", page_layout: :portrait)
        @collections  = args[:collections]
        @from_date    = args[:from_date]
        @to_date      = args[:to_date]
        @cooperative  = args[:cooperative]
        @view_context = args[:view_context]
        heading
        summary
        loan_collections
        font Rails.root.join("app/assets/fonts/open_sans_light.ttf")
      end
      private
      def display_commercial_document_for(entry)
        if entry.commercial_document.try(:member).present?
          entry.commercial_document.try(:member).try(:full_name)
        elsif entry.commercial_document.try(:borrower).present?
          entry.commercial_document.try(:borrower).try(:full_name)
        else
          entry.commercial_document.try(:name)
        end
      end
      def price(number)
        view_context.number_to_currency(number, :unit => "P ")
      end

      def heading
        bounding_box [280, 770], width: 50 do
          image "#{Rails.root}/app/assets/images/#{cooperative.abbreviated_name.downcase}_logo.jpg", width: 55, height: 55
        end
        bounding_box [340, 770], width: 200 do
            text "#{cooperative.abbreviated_name }", style: :bold, size: 20
            text "#{cooperative.name.try(:upcase)}", size: 8
            text "#{cooperative.address}", size: 8
        end
        bounding_box [0, 770], width: 400 do
          text "LOAN COLLECTIONS", style: :bold, size: 12
          move_down 2
          text "Date Covered: #{from_date.strftime("%b. %e, %Y")} - #{to_date.strftime("%b. %e, %Y")}", size: 10
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
        table([["Payments Count", "#{collections.count}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 12}, column_widths: [120, 100]) do
          cells.borders = []
          column(1).align = :right

        end
        move_down 5

        table([["Total Principal", "#{price(cooperative.loan_products.total_credits_balance(from_date: from_date, to_date: to_date))}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 12}, column_widths: [120, 100]) do
          cells.borders = []
          column(1).align = :right

        end
        move_down 5


        table([["Total Interest", "#{price(cooperative.loan_products.interest_revenue_accounts.credits_balance(from_date: from_date, to_date: to_date))}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 12}, column_widths: [120, 100]) do
          cells.borders = []
          column(1).align = :right
        end
        move_down 5


        table([["Total Penalty", "#{price(cooperative.loan_products.penalty_revenue_accounts.credits_balance(from_date: from_date, to_date: to_date))}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 12}, column_widths: [120, 100]) do
          cells.borders = []
          column(1).align = :right

        end
        move_down 5
        stroke do
          stroke_color 'CCCCCC'
          line_width 0.5
          stroke_horizontal_rule
        end
        move_down 5
        table([["Total Collection", "#{price(cooperative.loan_products.loan_payments(from_date: from_date, to_date: to_date))}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 12}, column_widths: [120, 100]) do
          cells.borders = []
          column(1).align = :right

        end
        move_down 10

      end

      def loan_collections
       text "Loan Collections", style: :bold, size: 10, color: "DB4437"
       # if cooperative.entries.loan_payments.recorded_by(recorder: employee).entered_on(from_date: date, to_date: date).present?
         table([["Borrower", "Date", "OR #", "Principal", "Interest", "Penalty", "Total"]], header: true, cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [80, 80, 60, 70, 70, 70, 80]) do
           column(3).align = :right
           column(4).align = :right
           column(5).align = :right
           column(6).align = :right
           row(0).background_color = 'DDDDDD'
           row(0).font_style = :bold
         end
       # else
       #   move_down 5
       #   text "    No Loan Collections for #{date.strftime("%B %e, %Y")}", size: 10
       # end
       stroke do
         stroke_color 'CCCCCC'
         line_width 0.2
         stroke_horizontal_rule
         move_down 5
       end

       collections.each do |entry|
          table(
           cooperative.loans.for_entry(entry: entry).map{ |loan| [
            "#{loan.borrower_name}",
            "#{entry.entry_date.strftime("%b. %e, %Y")}",
            "#{entry.reference_number}",
            price(entry.credit_amounts.loan_principal_amount(loan: loan)),
            price(entry.credit_amounts.loan_interest_amount(loan: loan)),
            price(entry.credit_amounts.loan_penalty_amount(loan: loan)),
            price(entry.credit_amounts.total_loan_payment(loan: loan))] }, column_widths: [80, 80, 60, 70, 70, 70, 80], cell_style: { inline_format: true, size: 9 }) do

           column(3).align = :right
           column(4).align = :right
           column(5).align = :right
           column(6).align = :right
          end
        end
        table([["", "", "TOTAL",
          "#{price(cooperative.loan_products.accounts.credits_balance(from_date: from_date, to_date: to_date))}",
          "#{price(cooperative.loan_products.interest_revenue_accounts.credits_balance(from_date: from_date, to_date: to_date))}",
          "#{price(cooperative.loan_products.penalty_revenue_accounts.credits_balance(from_date: from_date, to_date: to_date))}",
          "#{price(cooperative.loan_products.accounts_with_revenue_accounts.credits_balance(from_date: from_date, to_date: to_date))}"


          ]], column_widths: [80, 80, 60, 70, 70, 70, 80], cell_style: { inline_format: true, size: 9 }) do
          cells.borders = []
          column(3).align = :right
          column(4).align = :right
          column(5).align = :right
          column(6).align = :right
        end


   end
 end

  end
end
