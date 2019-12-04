module Migrators
  class Loan
    attr_reader :loan, :loan_product, :current_account, :interest_revenue_account, :penalty_revenue_account, :accrued_income_account

    def initialize(loan:)
      @loan                             = loan
      @loan_product                     = @loan.loan_product
      @current_account                  = @loan_product.current_account
      @interest_revenue_account         = @loan_product.interest_revenue_account
      @penalty_revenue_account          = @loan_product.penalty_revenue_account
      @accrued_income_account           = @loan_product.accrued_income_account
    end

    def migrate_entries!
      migrate_receivable_entries
      migrate_interest_revenue_entries
      migrate_penalty_revenue_entries
      migrate_accrued_income_entries
    end

    private

    def migrate_receivable_entries
      current_account.amounts.where(commercial_document_id: loan.id).each do |amount|
        amount.update!(account: loan.receivable_account)
      end
    end

    def migrate_interest_revenue_entries
      interest_revenue_account.amounts.where(commercial_document_id: loan.id).each do |amount|
        amount.update!(account: loan.interest_revenue_account)
      end
    end

    def migrate_penalty_revenue_entries
      penalty_revenue_account.amounts.where(commercial_document_id: loan.id).each do |amount|
        amount.update!(account: loan.penalty_revenue_account)
      end
    end

    def migrate_accrued_income_entries
      accrued_income_account.amounts.where(commercial_document_id: loan.id).each do |amount|
        amount.update!(account: loan.accrued_income_account)
      end
    end
  end
end
