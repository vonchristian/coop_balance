module Programs
  module PaymentStatusFinders
    class OneTimePayment
      attr_reader :program

      def initialize(args={})
        @program = args.fetch(:program)
      end

      def paid?
        program.account.credit_amounts.present?
      end
    end
  end
end
