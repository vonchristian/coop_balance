module LoansModule
  class PaymentClassifier
    attr_reader :loan, :entry, :loan_product

    def initialize(args)
      @loan         = args.fetch(:loan)
      @entry        = args.fetch(:entry)
      @loan_product = @loan.loan_product
    end

    def principal
      entry.amounts.for_commercial_document(commercial_document: loan).for_account(account_id: loan.principal_account.id).total
    end

    def interest
      entry.amounts.for_commercial_document(commercial_document: loan).for_account(account_id: loan_product.current_interest_config_interest_revenue_account.id).total
    end

    def penalty
      entry.amounts.for_commercial_document(commercial_document: loan).for_account(account_id: loan_product.penalty_revenue_account.id).total
    end

    def total_cash_payment
      entry.total_cash_amount
    end
  end
end
