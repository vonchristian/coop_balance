module LoansModule
  module Reports
    class LoanCollectionsPdf < Prawn::Document
      attr_reader :collections, :from_date, :to_date, :cooperative, :loan_product, :organization, :view_context
      def initialize(args={})
        super(margin: 30, page_size: "A4", page_layout: :portrait)
        @collections  = args[:collections]
        @from_date    = args[:from_date]
        @to_date      = args[:to_date]
        @cooperative  = args[:cooperative]
        @view_context = args[:view_context]
        @loan_product = args[:loan_product]
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
        if loan_product.present?
          table([["Loan Product", "#{loan_product.name.upcase}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 12}, column_widths: [120, 100]) do
            cells.borders = []
            column(1).align = :right

          end
          move_down 5

        end
        table([["Collections Count", "#{collections.count}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 12}, column_widths: [120, 100]) do
          cells.borders = []
          column(1).align = :right

        end
        move_down 5

        table([["Total Principal",
          "#{price(LoansModule::Payments::Aggregator.new(collections: collections, from_date: from_date, to_date: to_date, cooperative: cooperative).total_principals)}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 12}, column_widths: [120, 100]) do
          cells.borders = []
          column(1).align = :right

        end
        move_down 5


        table([["Total Interest", "#{price(LoansModule::Payments::Aggregator.new(collections: collections, from_date: from_date, to_date: to_date, cooperative: cooperative).total_interests)}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 12}, column_widths: [120, 100]) do
          cells.borders = []
          column(1).align = :right
        end
        move_down 5


        table([["Total Penalty", "#{price(LoansModule::Payments::Aggregator.new(collections: collections, from_date: from_date, to_date: to_date, cooperative: cooperative).total_penalties)}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 12}, column_widths: [120, 100]) do
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
        table([["Total Collections", "#{price(LoansModule::Payments::Aggregator.new(collections: collections, from_date: from_date, to_date: to_date, cooperative: cooperative).total_cash_payments)}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 12}, column_widths: [120, 100]) do
          cells.borders = []
          column(1).align = :right
        end
        move_down 10

      end

      def loan_collections
        if collections.present?
         table([["Borrower", "Date", " #", "Principal", "Interest", "Penalty", "Total"]], header: true, cell_style: { inline_format: true, size: 10, font: "Helvetica"}, column_widths: [80, 80, 60, 70, 70, 70, 80]) do
           column(3).align = :right
           column(4).align = :right
           column(5).align = :right
           column(6).align = :right
           row(0).background_color = 'DDDDDD'
           row(0).font_style = :bold
         end
         stroke do
           stroke_color 'CCCCCC'
           line_width 0.2
           stroke_horizontal_rule
           move_down 5
         end
         collections.each do |entry|
           cooperative.loans.for_entry(entry: entry).each do |loan|
             table(
              [["#{loan.borrower_name}",
              "#{entry.entry_date.strftime("%b. %e, %Y")}",
              "#{entry.reference_number}",
              price(LoansModule::Payments::Classifier.new(loan: loan, entry: entry).principal),
              price(LoansModule::Payments::Classifier.new(loan: loan, entry: entry).interest),
              price(LoansModule::Payments::Classifier.new(loan: loan, entry: entry).penalty)
            ]], column_widths: [100,50,50,50,50,50])
            end
          end
        else
          move_down 5
          text "    No Loan Collections for #{from_date.strftime("%B %e, %Y")}-#{to_date.strftime("%B %e, %Y")}", size: 10
        end
      end
    end
  end
end
