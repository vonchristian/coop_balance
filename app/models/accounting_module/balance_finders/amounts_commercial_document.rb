module AccountingModule
  module BalanceFinders
    class AmountsCommercialDocument < BaseBalanceFinder
      attr_reader :commercial_document

      def post_initialize(args)
        @commercial_document = args.fetch(:commercial_document)
      end

      def compute
        amounts.where(commercial_document: commercial_document).
        total
      end
    end
  end
end
