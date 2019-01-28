module AccountingModule
  module BalanceFinders
    class Office
      attr_reader :amounts, :office

      def initialize(args={})
        @office = args.fetch(:office)
        @amounts = args.fetch(:amounts)
      end

      def compute
        amounts.joins(:entry).
        where('entries.office_id' => office.id).
        total
      end
    end
  end
end
