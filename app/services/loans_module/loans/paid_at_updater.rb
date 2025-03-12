module LoansModule
  module Loans
    class PaidAtUpdater
      attr_reader :loan, :date

      def initialize(loan:, date:)
        @loan = loan
        @date = date
      end

      def update_paid_at!
        return unless loan.principal_balance.zero?

        loan.update!(paid_at: date)
      end
    end
  end
end
