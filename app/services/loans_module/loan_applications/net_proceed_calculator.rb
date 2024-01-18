module LoansModule
  module LoanApplications
    class NetProceedCalculator
      attr_reader :loan_application, :cart, :voucher

      def initialize(loan_application:)
        @loan_application = loan_application
        @cart             = @loan_application.cart
        @voucher          = @loan_application.voucher
      end

      def net_proceed
        loan_application.loan_amount.amount -
          total_charges
      end

      def total_charges
        if voucher.present?
          voucher.voucher_amounts.credit.total
        elsif cart.present?
          cart.voucher_amounts.credit.total
        else
          0
        end
      end
    end
  end
end