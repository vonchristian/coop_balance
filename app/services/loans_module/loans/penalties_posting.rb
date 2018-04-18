module LoansModule
  module Loans
    class PenaltiesPosting
      def initialize(options={})
        @loans    = LoansModule::Loan.past_due
        @date     = options[:date] || Date.today
        @employee = options[:employee]
      end
      def post!
        entry = AccountingModule::Entry.new(
        origin: @employee.office,
        entry_date: @date,
        recorder: @employee,
        description: "Penalty posting on #{@date.to_date.strftime("%B %e, %Y")}"
        )
        @loans.each do |loan|
          debit_amount = AccountingModule::DebitAmount.new(
          amount: loan.loan_penalty_computation,
          account: loan.loan_product_penalty_revenue_account,
          commercial_document: loan)

          credit_amount = AccountingModule::CreditAmount.new(
          amount: loan.loan_penalty_computation,
          account: loan.loan_product_penalty_receivable_account,
          commercial_document: loan)

          entry.debit_amounts << debit_amount
          entry.credit_amounts << credit_amount
        end
        entry.save
      end
    end
  end
end
