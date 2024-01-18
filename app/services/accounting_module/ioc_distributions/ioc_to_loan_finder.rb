module AccountingModule
  module IocDistributions
    class IocToLoanFinder
      attr_reader :cart, :office

      def initialize(cart:)
        @cart           = cart
        @employee       = @cart.employee
        @office         = @employee.office
      end

      def loan_ids
        loan_ids = []
        ids = cart.voucher_amounts.pluck(:account_id).uniq.compact.flatten
        loan_ids << LoansModule::Loan.where(receivable_account_id: ids).ids
        loan_ids << LoansModule::Loan.where(interest_revenue_account_id: ids).ids
        loan_ids << LoansModule::Loan.where(penalty_revenue_account_id: ids).ids
        loan_ids.flatten.compact.uniq
      end

      def principal_amount(loan)
        cart.voucher_amounts.where(account: loan.receivable_account).total
      end

      def interest_amount(loan)
        cart.voucher_amounts.where(account: loan.interest_revenue_account).total
      end

      def penalty_amount(loan)
        cart.voucher_amounts.where(account: loan.penalty_revenue_account).total
      end

      def total_amount(loan)
        principal_amount(loan) +
          interest_amount(loan) +
          penalty_amount(loan)
      end
    end
  end
end