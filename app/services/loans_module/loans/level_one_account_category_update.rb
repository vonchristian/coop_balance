module LoansModule 
  module Loans 
    class LevelOneAccountCategoryUpdate 
      attr_reader :loan, :receivable_account
      def initialize(loan:)
        @loan                       = loan 
        @loan_aging_group           = @loan.loan_aging_group
        @receivable_account         = @loan.receivable_account
        @loan_product               = @loan.loan_product
        @office                     = @loan.office
        @office_loan_product        = @office.office_loan_products.find_by(loan_product: @loan_product)
        
      end 

      def update_category!
        receivable_account.update!(level_one_account_category: level_one_account_category)
      end 

      def level_one_account_category
        @office.office_loan_product_aging_groups.where(loan_aging_group: @loan_aging_group, office_loan_product: @office_loan_product).current.level_one_account_category
      end

      # def level_one_account_category
      #   office 
      #   loan_product
      #   loan_aging_group
      #   office.office_loan_product_aging_groups.where(office_loan_product: office_loan_product, loan_aging_group: loan_aging_group).current.level_one_account_category

     
    end 
  end 
end 