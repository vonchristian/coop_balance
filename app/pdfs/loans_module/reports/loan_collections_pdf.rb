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
        entries_table
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
      def total_amount(entry)
        principal_amount(entry) +
        interest_amount(entry) +
        penalty_amount(entry)
      end

      def principal_amount(entry)
        entry.credit_amounts.where(account: cooperative.loan_products.accounts).where(commercial_document: cooperative.loans).map{|a| a.amount.amount }.sum
      end
      def interest_amount(entry)
        entry.credit_amounts.where(account: cooperative.loan_products.interest_revenue_accounts).where(commercial_document: cooperative.loans).map{|a| a.amount.amount }.sum
      end
      def penalty_amount(entry)
        entry.credit_amounts.where(account: cooperative.loan_products.penalty_revenue_accounts).map{|a| a.amount.amount }.sum
      end

      def loan_product(entry)
        ids = entry.amounts.pluck(:commercial_document_id)
        loan_products = cooperative.loans.where(id: ids).pluck(:loan_product_id)
        cooperative.loan_products.where(id: loan_products).pluck(:name).join(",")
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
          text "LOAN RELEASES", style: :bold, size: 12
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


        table([["Total Interest", "#{price(total_interests)}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 12}, column_widths: [120, 100]) do
          cells.borders = []
          column(1).align = :right
        end
        move_down 5


        table([["Total Penalty", "#{price(total_penalties)}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 12}, column_widths: [120, 100]) do
          cells.borders = []
          column(1).align = :right

        end
        move_down 5
        stroke do
          stroke_color 'CCCCCC'
          line_width 0.5
          stroke_horizontal_rule

        end

        table([["Total Collection", "#{price(total_collections)}"]], cell_style: {padding: [0,0,0,0], inline_format: true, size: 12}, column_widths: [120, 100]) do
          cells.borders = []
          column(1).align = :right

        end
        move_down 10

      end
      def total_interests
        collections.map{|a| interest_amount(a) }.sum
      end
      def total_penalties
        collections.map{|a| penalty_amount(a) }.sum
      end
      def total_collections
        collections.map{|a| total_amount(a) }.sum
      end
      def entries_table
        if !collections.any?
          move_down 10
          text "No entries data.", align: :center
        else
          table(collections_table, cell_style: { inline_format: true, size: 6}, column_widths: [100]) do
            row(0).font_style= :bold
            row(0).background_color = 'DDDDDD'
          end
        end
      end
      def collections_table
        [["DATE", "BORROWER","LOAN", "PRINCIPAL", "INTEREST",  "PENALTY", "TOTAL"]] +
        @collections_table ||= collections.map{ |entry|
        [entry.entry_date.strftime("%b. %e, %Y"),
          entry.commercial_document_name,
          loan_product(entry),
          price(principal_amount(entry)),
          price(interest_amount(entry)),
          price(penalty_amount(entry)),
          price(total_amount(entry))]}
      end
    end
  end
end
