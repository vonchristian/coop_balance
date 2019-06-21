module AccountingModule
  module Reports
    class IncomeStatementPdf < Prawn::Document
      attr_reader :view_context, :to_date, :cooperative, :report
      def initialize(args={})
        super(margin: 40,  page_size: [612, 936], page_layout: :portrait)

        @to_date      = args[:to_date]
        @report       = args.fetch(:report)
        @view_context = args[:view_context]
        @cooperative  = args[:cooperative]
        heading
        revenues_table
        expenses_table
      end

      private
      def price(number)
        view_context.number_to_currency(number, :unit => "P ")
      end
      def heading
        text report.title.upcase, size: 11, style: :bold
        text "As of #{to_date.strftime("%B, %e, %Y")}"
        move_down 5
        stroke_horizontal_rule
        move_down 10
      end
      def revenues_table
        report.account_categories.each do |category|
          text category.title
        end
      end
      def expenses_table
      end

    end
  end
end
