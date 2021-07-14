module Accounting
  module Amounts
    module AmountBalancing

      def total
        Money.new(self.pluck(:amount_cents).sum).amount
      end

      def balance(args={})
        balance_finder(args).new(args.merge!(amounts: self)).compute
      end

      private

      def balance_finder(args={})
        if args.present?
          klass = args.compact.keys.sort.map{ |key| key.to_s.titleize }.join.gsub(" ", "")
        else
          klass = "DefaultBalanceFinder"
        end
        ("AccountingModule::BalanceFinders::#{klass}").constantize
      end
    end
  end
end
