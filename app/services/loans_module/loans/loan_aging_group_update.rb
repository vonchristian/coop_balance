module LoansModule
  module Loans
    class LoanAgingGroupUpdate
      attr_reader :loan, :office, :loan_aging_groups, :date

      def initialize(loan:, date:)
        @loan                = loan
        @date                = date
        @office              = @loan.office
        @loan_aging_groups   = @office.loan_aging_groups
        
      end

      def update_loan_aging_group!
        loan_aging_groups.each do |loan_aging_group|
          number_of_days_past_due = loan.number_of_days_past_due(date: date)
          
          if loan_aging_group.num_range.include?(number_of_days_past_due)
            update_loan_aging_group(loan_aging_group)
            update_category
          end
        end
      end
      
      private 

      def update_loan_aging_group(loan_aging_group)
        loan.loan_agings.find_or_create_by(loan_aging_group: loan_aging_group, date: date)
        loan.update(loan_aging_group: loan_aging_group)
      end 

      def update_category
        LoansModule::Loans::LevelOneAccountCategoryUpdate.new(loan: loan).update_category!
      end
    end
  end
end
