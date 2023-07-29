module AccountCreators
  class LoanApplication
    attr_reader :loan_application, :loan_product, :office, :receivable_ledger, :interest_revenue_ledger

    def initialize(loan_application:)
      @loan_application                  = loan_application
      @office                            = @loan_application.office
      @loan_product                      = @loan_application.loan_product
      @office_loan_product               = @office.office_loan_products.find_by(loan_product: @loan_product)
      @interest_revenue_ledger = @office_loan_product.interest_revenue_ledger
      @office_loan_product_aging_group   = @office_loan_product.office_loan_product_aging_groups.current
      @receivable_ledger      = @office_loan_product_aging_group.receivable_ledger
    end

    def create_accounts!
      create_receivable_account
      create_interest_revenue_account
    end

    private

    def create_receivable_account
      if loan_application.receivable_account.blank?
        account = office.accounts.assets.create!(
          name:   "#{loan_product.name} - #{SecureRandom.uuid}",
          code:   SecureRandom.uuid,
          ledger: receivable_ledger
        )
        loan_application.update(receivable_account: account)
      end
    end

    def create_interest_revenue_account
      if loan_application.interest_revenue_account.blank?
        account = office.accounts.revenues.create!(
          name:                       "Interest Income - #{loan_product.name} - #{SecureRandom.uuid}",
          code:                       "INT-#{loan_application.account_number}",
          ledger: interest_revenue_ledger
        )
        loan_application.update(interest_revenue_account: account)
      end
    end
  end
end
