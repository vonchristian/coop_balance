module AccountingModule
  module IocDistributions
    class IocToLoan
      include ActiveModel::Model
      attr_accessor :loan_id, :cart_id, :employee_id, :principal_amount, :interest_amount, :penalty_amount

      validates :loan_id, :cart_id, :employee_id, presence: true
      validates :principal_amount, :interest_amount, :penalty_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

      def process!
        return unless valid?

        ApplicationRecord.transaction do
          create_principal_amount
          create_interest_amount
          create_penalty_amount
        end
      end

      private

      def create_principal_amount
        return unless principal_amount.to_f.positive?

        find_cart.voucher_amounts.credit.create!(
          amount: principal_amount.to_f,
          account: find_loan.receivable_account
        )
      end

      def create_interest_amount
        return unless interest_amount.to_f.positive?

        find_cart.voucher_amounts.credit.create!(
          amount: interest_amount.to_f,
          account: find_loan.interest_revenue_account
        )
      end

      def create_penalty_amount
        return unless penalty_amount.to_f.positive?

        find_cart.voucher_amounts.credit.create!(
          amount: penalty_amount.to_f,
          account: find_loan.penalty_revenue_account
        )
      end

      def find_cart
        find_employee.carts.find(cart_id)
      end

      def find_employee
        User.find(employee_id)
      end

      def find_loan
        find_office.loans.find(loan_id)
      end

      def find_office
        find_employee.office
      end
    end
  end
end
