module LoansModule
  module Loans
    class LoanAgingGroupUpdate
      attr_reader :loan, :office, :loan_aging_groups, :date, :office_loan_product

      def initialize(loan:, date:)
        @loan                = loan
        @date                = date
        @office              = @loan.office
        @loan_aging_groups   = @office.loan_aging_groups
        @office_loan_product = @office.office_loan_products.find_by(loan_product: @loan.loan_product)
      end

      def update_loan_aging_group!
        loan_aging_groups.each do |loan_aging_group|
          if loan_aging_group.num_range.include?(loan.number_of_days_past_due.to_i)
            create_loan_aging_group(loan_aging_group)
            update_loan_receivable_account_level_one_account_category(loan_aging_group)
          end
        end
      end
      
      private 

      def create_loan_aging_group(loan_aging_group)
        loan.loan_agings.find_or_create_by(loan_aging_group: loan_aging_group, date: date)
      end 

      def update_loan_receivable_account_level_one_account_category(loan_aging_group)
        if level_one_account_category(loan_aging_group).present? 
          loan.receivable_account.update(level_one_account_category: level_one_account_category(loan_aging_group))
        end 
      end

      def level_one_account_category(loan_aging_group)
        office_loan_product_aging_group = loan_aging_group.office_loan_product_aging_groups.where(office_loan_product: office_loan_product).current 
        office_loan_product_aging_group.level_one_account_category
      end 
    end
  end
end
