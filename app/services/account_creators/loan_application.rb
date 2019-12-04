module AccountCreators
  class LoanApplication 
    attr_reader :loan_application, :loan_product

    def initialize(loan_application:)
      @loan_application = loan_application
      @loan_product     = @loan_application.loan_product
    end

    def create_accounts!
      create_receivable_account 
      create_interest_revenue_account 
    end

    private 

    def create_receivable_account
      if loan_application.receivable_account.blank?
        account = AccountingModule::Asset.create!(
          name: "#{loan_product.name} - #{loan_application.account_number}",
          code: loan_application.account_number
        )
        loan_application.update(receivable_account: account)
      end
    end

    def create_interest_revenue_account
      if loan_application.interest_revenue_account.blank?
        account = AccountingModule::Revenue.create!(
          name: "Interest Income - #{loan_product.name} - #{loan_application.account_number}",
          code: "INT-#{loan_application.account_number}"
        )
        loan_application.update(interest_revenue_account: account)
      end
    end
  end
end