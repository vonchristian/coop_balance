module AccountCreators 
  module Loans 
    class LoanAgingReceivableAccount 
      attr_reader :loan_aging, :loan, :receivable_account_category

      def initialize(loan_aging:)
        @loan_aging                      = loan_aging 
        @loan                            = @loan_aging.loan 
        @loan_aging_group                = @loan_aging.loan_aging_group
        @loan_product                    = @loan.loan_product
        @office_loan_product             = @office.office_loan_products.find_by(loan_product: @office_loan_product)
        @office_loan_product_aging_group = @office_loan_product.office_loan_product_aging_groups.find_by(loan_aging_group: @loan_aging_group)
        @receivable_account_category     = @office_loan_product_aging_group.level_one_account_category
      end 
      def create_accounts! 
        create_receivable_account
        create_accountable_accounts
      end 

      private 

      def create_receivable_account!
        if loan_aging.receivable_account.blank?
          account = office.accounts.assets.create!(
            name:                       receivable_account_name,
            code:                       SecureRandom.uuid,
            level_one_account_category: receivable_account_category)
          loan_aging.update(receivable_account: account)
        end
      end

      def create_accountable_accounts
        loan.accounts << loan_aging.receivable_account
      end 

      private 

      def receivable_account_name
        "#{loan_aging_group.title} - #{loan.account_number}"
      end
    end 
  end 
end 