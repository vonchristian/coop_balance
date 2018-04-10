module LoansModule
  module Loans
    class UnearnedInterestIncomePostingService
      def initialize(loan, amortization_schedule, employee)
        @loan = loan
        @amortization_schedule = amortization_schedule
        @employee = employee
      end
      def post!
        if postable?
          AccountingModule::Entry.create!(
            origin: @employee.office,
            recorder: @employee,
            commercial_document: @loan,
            description: "Unearned interest income posting for #{@loan.borrower_name}",
            entry_date: @amortization_schedule.date,
            debit_amounts_attributes: [
              account: @loan.loan_product_unearned_interest_income_account,
              amount: @amortization_schedule.interest,
              commercial_document: @amortization_schedule],
            credit_amounts_attributes: [
              account: @loan.loan_product_interest_revenue_account,
              amount: @amortization_schedule.interest,
              commercial_document: @amortization_schedule]
            )
        end
      end
      private
      def postable?
        (Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).cover?(@amortization_schedule.date)
      end
    end
  end
end
