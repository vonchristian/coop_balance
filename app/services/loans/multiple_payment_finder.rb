module Loans
  class MultiplePaymentFinder
    attr_reader :cart

    def initialize(args)
      @cart = args.fetch(:cart)
    end
    def total_cash_payment
      cart.voucher_amounts.where(account: Employees::EmployeeCashAccount.cash_accounts).total
    end
    def loan_ids
      ids = cart.voucher_amounts.pluck(:commercial_document_id).uniq.compact.flatten
    end

    def principal(loan)
      cart.voucher_amounts.where(account: loan.receivable_account).sum(&:amount)
    end

    def interest(loan)
      cart.voucher_amounts.where(account: loan.interest_revenue_account).sum(&:amount)
    end

    def penalty(loan)
      cart.voucher_amounts.where(account: loan.penalty_revenue_account).sum(&:amount)
    end
    
    def total_cash(loan)
      principal(loan) +
      interest(loan) +
      penalty(loan)
    end
  end
end
