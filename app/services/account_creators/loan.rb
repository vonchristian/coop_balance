module AccountCreators
  class Loan
    attr_reader :loan, :loan_product

    def initialize(loan:)
      @loan = loan
      @loan_product = @loan.loan_product
    end

    def create_accounts!
      create_receivable_account
      create_interest_revenue_amount
      create_penalty_revenue_account
    end

    private
    def create_receivable_account
      if loan.receivable_account.blank?
        account = AccountingModule::Asset.create!(
          name: "#{loan_product.name} - #{loan.account_number}",
          code: loan.account_number
        )
        loan.update(receivable_account: account)
      end
    end
    def create_interest_revenue_amount
      if loan.interest_revenue_account.blank?
        account = AccountingModule::Revenue.create!(
          name: "Interest Income - #{loan_product.name} - #{loan.account_number}",
          code: "INT-#{loan.account_number}"
        )
        loan.update(interest_revenue_account: account)
      end
    end
    def create_penalty_revenue_account
      if loan.penalty_revenue_account.blank?
        account = AccountingModule::Revenue.create!(
          name: "Penalty Income - #{loan_product.name} - #{loan.account_number}",
          code: "PEN-#{loan.account_number}"
        )
        loan.update(penalty_revenue_account: account)
      end
    end

  end
end
