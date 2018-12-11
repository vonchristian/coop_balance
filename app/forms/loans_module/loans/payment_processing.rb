module LoansModule
  module Loans
    class PaymentProcessing
      include ActiveModel::Model
      attr_accessor :loan_id,
                :principal_amount,
                :interest_amount,
                :penalty_amount,
                :reference_number,
                :date,
                :description,
                :employee_id,
                :cash_account_id,
                :account_number
      validates :principal_amount, :interest_amount, :penalty_amount, presence: true, numericality: true
      validates :reference_number, :date, :description, presence: true

      def process!
        ActiveRecord::Base.transaction do
          create_voucher_amount
        end
      end

      def find_voucher
        Voucher.find_by(account_number: account_number)
      end

      def find_loan
        LoansModule::Loan.find(loan_id)
      end

      def find_employee
        User.find(employee_id)
      end

      private
      def create_voucher_amount
        interest_revenue_account = find_loan.loan_product_interest_revenue_account
        penalty_revenue_account  = find_loan.loan_product_penalty_revenue_account
        debit_account            = find_cash_account
        voucher = Voucher.new(
        account_number:   account_number,
        office:           find_employee.office,
        cooperative:      find_employee.cooperative,
        payee:            find_loan.borrower,
        reference_number: reference_number,
        description:      description,
        preparer:         find_employee,
        date:             date)

        if interest_amount.to_f > 0
          voucher.voucher_amounts.credit.build(
          amount:              interest_amount.to_f,
          account:             interest_revenue_account,
          commercial_document: find_loan)
        end

        if penalty_amount.to_f > 0
          voucher.voucher_amounts.credit.build(
          amount:              penalty_amount.to_f,
          account:             penalty_revenue_account,
          commercial_document: find_loan)
        end

        if principal_amount.to_f > 0
          voucher.voucher_amounts.credit.build(
          amount:              principal_amount.to_f,
          account:             find_loan.principal_account,
          commercial_document: find_loan)
        end

        voucher.voucher_amounts.debit.build(
        amount:              total_amount,
        account:             find_cash_account,
        commercial_document: find_loan)
        voucher.save!
      end

      def find_cash_account
        AccountingModule::Account.find(cash_account_id)
      end

      def total_amount
        principal_amount.to_f +
        interest_amount.to_f +
        penalty_amount.to_f
      end
    end
  end
end
