module LoansModule 
  module Loans 
    class LevelOneAccountCategoryUpdate 
      attr_reader :loan, :level_one_account_category, :receivable_account
      def initialize(loan:)
        @loan                       = loan 
        @loan_aging_group           = @loan.loan_aging_group
        @receivable_account         = @loan.receivable_account
        @loan_product               = @loan.loan_product
        @office                     = @loan.office
        @office_loan_product        = @office.office_loan_products.find_by(loan_product: @loan_product)
        @level_one_account_category =  @office.office_loan_product_aging_groups.find_by(loan_aging_group: @loan_aging_group).level_one_account_category
        
      end 

      def update_category!
        receivable_account.update!(level_one_account_category: level_one_account_category)
      end 

     
    end 
  end 
end 