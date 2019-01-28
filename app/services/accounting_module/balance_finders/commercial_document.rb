module AccountingModule
  module BalanceFinders
    class CommercialDocument
      attr_reader :commercial_document, :amounts

      def initialize(args)
        @amounts             = args.fetch(:amounts)
        @commercial_document = args.fetch(:commercial_document)
      end

      def compute
        amounts.where(commercial_document: commercial_document).
        total
      end
    end
  end
end
