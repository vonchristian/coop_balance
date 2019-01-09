module AccountingModule
  module BalanceFinders
    class AmountsCommercialDocumentToDate
      attr_reader :commercial_document, :from_date, :to_date, :amounts

      def initialize(args)
        @commercial_document = args.fetch(:commercial_document)
        @amounts = args.fetch(:amounts)
        @from_date = 999.years.ago
        @to_date   = args.fetch(:to_date)
      end

      def compute
        date_range = DateRange.new(from_date: from_date, to_date: to_date)
        amounts.where(commercial_document: commercial_document)
        .joins(:entry).
        where('entries.entry_date' => date_range.range).
        total
      end
    end
  end
end
