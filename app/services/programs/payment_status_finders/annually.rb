module Programs
  module PaymentStatusFinders
    class Annually
      attr_reader :program, :from_date, :to_date
      def initialize(args={})
        @program = args.fetch(:program)
        @from_date = args.fetch(:from_date)
        @to_date   = args.fetch(:to_date)
      end

      def paid?
        payment = program.
        account.
        credit_amounts.
        entered_on(from_date: from_date, to_date: to_date)
        payment.present? && payment.total == program.amount
      end
    end
  end
end
