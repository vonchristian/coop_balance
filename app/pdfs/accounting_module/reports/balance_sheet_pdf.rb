module AccountingModule
  module Reports
    class BalanceSheetPdf < Prawn::Document
      attr_reader :view_context, :to_date, :cooperative, :report
      def initialize(args={})
        super(margin: 40,  page_size: [612, 936], page_layout: :portrait)

        @to_date      = args[:to_date]
        @report       = args.fetch(:report)
        @view_context = args[:view_context]
        @cooperative  = args[:cooperative]
        heading
        assets_table
        liabilities_and_equities_table
      end

      private
      def price(number)
        view_context.number_to_currency(number, :unit => "P ")
      end
      def heading
        text report.title
      end
      def assets_table
      end
      def liabilities_and_equities_table
      end

    end
  end
end
