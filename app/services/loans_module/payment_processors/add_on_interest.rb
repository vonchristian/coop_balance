module LoansModule
  module PaymentProcessors
    class AddOnInterest
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
                    :account_number,
                    :amortization_schedule_id

      validates :principal_amount, :interest_amount, :penalty_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
      validate :principal_amount_not_more_than_balance
      validates :reference_number, :date, :description, presence: true

      def process!
        ActiveRecord::Base.transaction do
          create_voucher!
        end
      end

      def find_voucher
        Voucher.find_by(account_number: account_number)
      end

      def find_loan
        LoansModule::Loan.find(loan_id)
      end

      def schedule_id
        return if amortization_schedule_id.blank?

        amortization_schedule_id
      end

      def find_employee
        User.find(employee_id)
      end

      def create_voucher!
        voucher = Voucher.new(
          account_number: account_number,
          office: find_employee.office,
          cooperative: find_employee.cooperative,
          payee: find_loan.borrower,
          reference_number: reference_number,
          description: description,
          preparer: find_employee,
          date: date
        )

        voucher.voucher_amounts << create_penalty_amount
        voucher.voucher_amounts << create_principal_amount
        voucher.voucher_amounts << create_interest_amount
        voucher.voucher_amounts << create_cash_amount
        voucher.save!
      end

      def create_cash_amount
        Vouchers::VoucherAmount.debit.create!(
          amount: total_amount,
          account: find_cash_account
        )
      end

      def create_interest_amount
        return unless interest_amount.to_f.positive?

        Vouchers::VoucherAmount.credit.create!(
          amount: interest_amount.to_f,
          account: find_loan.interest_revenue_account
        )
      end

      def create_penalty_amount
        return unless penalty_amount.to_f.positive?

        Vouchers::VoucherAmount.credit.create!(
          amount: penalty_amount.to_f,
          account: find_loan.penalty_revenue_account
        )
      end

      def create_principal_amount
        return unless principal_amount.to_f.positive?

        Vouchers::VoucherAmount.credit.create!(
          cooperative: find_loan.cooperative,
          amount: principal_amount.to_f,
          account: find_loan.receivable_account
        )
      end

      def find_cash_account
        AccountingModule::Account.find(cash_account_id)
      end

      def total_amount
        principal_amount.to_f +
          interest_amount.to_f +
          penalty_amount.to_f
      end

      def principal_amount_not_more_than_balance
        errors[:principal_amount] << 'Must be less than or equal to balance.' if principal_amount.to_f > find_loan.principal_balance
      end
    end
  end
end
