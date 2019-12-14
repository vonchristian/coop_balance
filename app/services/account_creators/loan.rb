module AccountCreators
  class Loan
    attr_reader :loan, :loan_product, :office, :receivable_account_category, :interest_revenue_account_category, :penalty_revenue_account_category

    def initialize(loan:)
      @loan                              = loan
      @loan_product                      = @loan.loan_product
      @office                            = @loan.office
      @receivable_account_category       = @office.office_loan_products.where(loan_product: @loan_product).last.receivable_account_category
      @interest_revenue_account_category = @office.office_loan_products.where(loan_product: @loan_product).last.interest_revenue_account_category
      @penalty_revenue_account_category  = @office.office_loan_products.where(loan_product: @loan_product).last.penalty_revenue_account_category
    end

    def create_accounts!
      create_receivable_account!
      create_interest_revenue_account!
      create_penalty_revenue_account!
    end

    private

    def create_receivable_account!
      if loan.receivable_account.blank?
        account = office.accounts.assets.create!(
          name:                       receivable_account_name,
          code:                       SecureRandom.uuid,
          level_one_account_category: receivable_account_category)
        loan.update(receivable_account: account)
        loan.accounts << account
      end
    end

    def create_interest_revenue_account!
      if loan.interest_revenue_account.blank?
        account = office.accounts.revenues.create!(
          name:                       interest_revenue_name,
          code:                       SecureRandom.uuid,
          level_one_account_category: interest_revenue_account_category
        )
        loan.update(interest_revenue_account: account)
        loan.accounts << account
      end
    end

    def create_penalty_revenue_account!
      if loan.penalty_revenue_account.blank?
        account = office.accounts.revenues.create!(
          name:                       penalty_revenue_name,
          code:                       SecureRandom.uuid,
          level_one_account_category: penalty_revenue_account_category)
        loan.update(penalty_revenue_account: account)
        loan.accounts << account
      end
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
