module Programs
  module PaymentStatusFinders
    class Annually
      attr_reader :program, :program_subscription, :date, :date_setter
      def initialize(args={})
        @program_subscription = args.fetch(:program_subscription)
        @date                 = args.fetch(:date)
        @date_setter          = @program_subscription.date_setter
      end

      def beginning_date
        program_subscription.date_setter.new(date: date).beginning_date
      end 

      def ending_date
        program_subscription.date_setter.new(date: date).ending_date
      end 

      def paid?
        payment = program_subscription.
        program_account.
        entries.
        entered_on(from_date: beginning_date, to_date: ending_date)
        payment.present? && payment.debit_amounts.total == program_subscription.amount
      end
    end
  end
end
