module Programs
  module PaymentStatusFinders
    class OneTimePayment
      attr_reader :program_subscription

      def initialize(args = {})
        @program_subscription = args.fetch(:program_subscription)
      end

      def paid?
        program_subscription
          .program_account
          .entries.present?
      end
    end
  end
end
