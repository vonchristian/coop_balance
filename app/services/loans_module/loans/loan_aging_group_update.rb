module LoansModule
  module Loans
    class LoanAgingGroupUpdate
      attr_reader :loan, :office, :loan_aging_groups, :date, :number_of_days_past_due

      def initialize(args={})
        @loan                    = args.fetch(:loan)
        @date                    = args[:date] || Time.zone.now
        @office                  = @loan.office
        @loan_aging_groups       = @office.loan_aging_groups
        @number_of_days_past_due = @loan.number_of_days_past_due(date: @date)
        
      end

      def process!
        loan_aging_groups.each do |loan_aging_group|
          if loan_aging_group.num_range.include?(number_of_days_past_due)
            update_loan_aging_group(loan_aging_group)
          end
        end
      end
      
      private 

      def update_loan_aging_group(loan_aging_group)
        LoansModule::Loans::LoanAging.create_or_find_by(loan: loan, loan_aging_group: loan_aging_group, date: date.to_date)
        loan.update!(loan_aging_group: loan_aging_group)
      end 
    end
  end
end
