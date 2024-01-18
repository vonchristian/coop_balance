module Programs
  module PaymentStatusFinders
    class Quarterly
      attr_reader :program, :program_subscription, :from_date, :to_date

      def initialize(args = {})
        @program_subscription = args.fetch(:program_subscription)
        @program              = @program_subscription.program
        @from_date            = args.fetch(:from_date).beginning_of_quarter
        @to_date              = args.fetch(:to_date).end_of_quarter
      end

      def paid?
        payment = program_subscription
                  .program_account
                  .entries
                  .entered_on(from_date: from_date, to_date: to_date)
        payment.present? && payment.debit_amounts.total == program.amount
      end
    end
  end
end
