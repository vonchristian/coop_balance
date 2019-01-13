module AccountingModule
  module BalanceFinders
    class AmountsCommercialDocumentFromDateToDate < BaseBalanceFinder
      attr_reader  :from_date, :to_date, :commercial_document

      def post_initialize(args)
        @from_date = args.fetch(:from_date)
        @to_date   = args.fetch(:to_date)
        @commercial_document = args.fetch(:commercial_document)
      end

      def compute
        date_range = DateRange.new(from_date: from_date, to_date: to_date)

        amounts.joins(:entry).
        where('entries.entry_date' => date_range.range).
        where(commercial_document: commercial_document).
        total
      end
    end
  end
end