module AccountCreators
  class Loan
    attr_reader :loan, :loan_product, :office
    def initialize(args)
      @loan         = args.fetch(:loan)
      @loan_product = args.fetch(:loan_product)
      @office       = @loan.office
    end

    def create_accounts!
      create_receivable_account!
      create_interest_revenue_account!
      create_penalty_revenue_account!
    end

    private
    def create_receivable_account!
      if loan.receivable_account.blank?
        account = AccountingModule::Accounts::Asset.create!(
          name:             receivable_account_name,
          code:             SecureRandom.uuid,
          level_one_account_category: loan_product.receivable_account_category,
          office:      loan.office)
        loan.update(receivable_account: account)
        loan.accounts << account
      end
    end

    def create_interest_revenue_account!
      if loan.interest_revenue_account.blank?
        account = AccountingModule::Revenue.create!(
          name:             interest_revenue_name,
          code:             SecureRandom.uuid,
          account_category: loan_product.interest_revenue_account_category,
          office:      loan.office
        )
        loan.update(interest_revenue_account: account)
        loan.accounts << account
      end
    end

    def create_penalty_revenue_account!
      if loan.penalty_revenue_account.blank?
        account = AccountingModule::Revenue.create!(
          name:             penalty_revenue_name,
          code:             SecureRandom.uuid,
          account_category: loan_product.penalty_revenue_account_category,
          office:      loan.office)
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
