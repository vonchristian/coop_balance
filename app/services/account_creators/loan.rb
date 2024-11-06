module AccountCreators
  class Loan
    attr_reader :loan, :loan_product, :office, :receivable_ledger, :interest_revenue_ledger, :penalty_revenue_ledger

    def initialize(loan:)
      @loan                            = loan
      @loan_product                    = @loan.loan_product
      @office                          = @loan.office
      @office_loan_product             = @office.office_loan_products.find_by(loan_product: @loan_product)
      @office_loan_product_aging_group = @office_loan_product.office_loan_product_aging_groups.current
      @interest_revenue_ledger         = @office.office_loan_products.find_by(loan_product: @loan_product).interest_revenue_ledger
      @penalty_revenue_ledger          = @office.office_loan_products.find_by(loan_product: @loan_product).penalty_revenue_ledger
      @receivable_ledger               = @office_loan_product_aging_group.receivable_ledger
    end

    def create_accounts!
      create_receivable_account!
      create_interest_revenue_account!
      create_penalty_revenue_account!
    end

    private

    def create_receivable_account!
      return if loan.receivable_account.present?

      account = office.accounts.asset.create!(
        name: receivable_account_name,
        code: SecureRandom.uuid,
        ledger: receivable_ledger
      )
      loan.update(receivable_account: account)
    end

    def create_interest_revenue_account!
      return if loan.interest_revenue_account.present?

      account = office.accounts.revenue.create!(
        name: interest_revenue_name,
        code: SecureRandom.uuid,
        ledger: interest_revenue_ledger
      )
      loan.update(interest_revenue_account: account)
    end

    def create_penalty_revenue_account!
      return if loan.penalty_revenue_account.present?

      account = office.accounts.revenue.create!(
        name: penalty_revenue_name,
        code: SecureRandom.uuid,
        ledger: penalty_revenue_ledger
      )
      loan.update(penalty_revenue_account: account)
    end

    def receivable_account_name
      "Loans Receivable - #{loan.loan_product_name} #{loan.account_number}"
    end

    def interest_revenue_name
      "Interest Income from Loans - #{loan.loan_product_name} #{loan.account_number}"
    end

    def penalty_revenue_name
      "Fines, Penalties, and Surcharges - #{loan.loan_product_name} #{loan.account_number}"
    end
  end
end
