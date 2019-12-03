module LoansModule
  module Loans
    class LoanAgingGroupUpdate
      attr_reader :loan, :office, :loan_aging_groups, :date

      def initialize(loan:, date:)
        @loan              = loan
        @date              = date
        @office            = @loan.office
        @loan_aging_groups = @office.loan_aging_groups
      end

      def update_loan_aging_group!
        loan_aging_groups.each do |loan_aging_group|
          if loan_aging_group.num_range.include?(loan.number_of_days_past_due.to_i)
            loan.loan_agings.find_or_create_by(loan_aging_group: loan_aging_group, date: date)
          end
        end
      end
    end
  end
end
