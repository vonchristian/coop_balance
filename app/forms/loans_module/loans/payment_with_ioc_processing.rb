module LoansModule
  module Loans
    class PaymentWithIocProcessing
      include ActiveModel::Model
      attr_accessor :loan_id,
                :share_capital_id,
                :amortization_schedule_id,
                :principal_amount,
                :interest_amount,
                :penalty_amount,
                :reference_number,
                :date,
                :description,
                :employee_id,
                :cash_account_id,
                :account_number
      validates :principal_amount, :interest_amount, :penalty_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
      validate :principal_amount_not_more_than_balance
      validates :reference_number, :date, :description, presence: true

      def process!
        ActiveRecord::Base.transaction do
          create_voucher
        end
      end

      def find_voucher
        Voucher.find_by(account_number: account_number)
      end

      def find_share_capital
        MembershipsModule::ShareCapital.find(share_capital_id)
      end

      def find_loan
        LoansModule::Loan.find(loan_id)
      end

      def find_employee
        User.find(employee_id)
      end

      def schedule_id
        if amortization_schedule_id.present?
          amortization_schedule_id
        end
      end

      private

      def create_voucher
        voucher = Voucher.new(
        account_number:   account_number,
        office:           find_employee.office,
        cooperative:      find_employee.cooperative,
        payee:            find_loan.borrower,
        reference_number: reference_number,
        description:      description,
        preparer:         find_employee,
        date:             date)

        create_interest_amount(voucher)
        create_penalty_amount(voucher)
        create_principal_amount(voucher)
        create_total_cash_amount(voucher)
        voucher.save!
      end

      def create_interest_amount(voucher)
        if interest_amount.to_f > 0
          voucher.voucher_amounts.credit.build(
          amount:              interest_amount.to_f,
          account:             find_loan.loan_product_interest_revenue_account)
        end
      end

      def create_penalty_amount(voucher)
        if penalty_amount.to_f > 0
          voucher.voucher_amounts.credit.build(
          amount:              penalty_amount.to_f,
          account:             find_loan.loan_product_penalty_revenue_account)
        end
      end

      def create_principal_amount(voucher)
        if principal_amount.to_f > 0
          voucher.voucher_amounts.credit.build(
          amount:              principal_amount.to_f,
          account:             find_loan.loan_product_current_account)
        end
      end

      def create_total_cash_amount(voucher)
        voucher.voucher_amounts.debit.build(
        amount:              total_amount.to_f,
        account:             find_share_capital.share_capital_product_interest_payable_account)
      end

      def find_cash_account
        AccountingModule::Account.find(cash_account_id)
      end

      def total_amount
        principal_amount.to_f +
        interest_amount.to_f +
        penalty_amount.to_f
      end

      def principal_and_interest_amount
        principal_amount.to_f +
        interest_amount.to_f
      end

      def principal_amount_for(interest_config)
        if interest_config.add_on?
          principal_and_interest_amount
        else
          principal_amount.to_f
        end
      end

      def principal_amount_not_more_than_balance
        errors[:principal_amount] << "Must be less than or equal to balance." if principal_amount.to_f > find_loan.principal_balance
      end
    end
  end
end
