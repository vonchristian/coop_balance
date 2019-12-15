module LoansModule
  module Loans
    class PaymentFromShareCapital
      include ActiveModel::Model

      attr_accessor :amount, :loan_id, :share_capital_id, :cart_id, :employee_id

      validates :amount, presence: true, numericality: { greater_than: 0.1 }
      validates :loan_id, :share_capital_id, :cart_id, :employee_id, presence: true

      def process!
        if valid?
          ApplicationRecord.transaction do
            create_voucher_amount
          end
        end
      end

      private
      def create_voucher_amount
        find_cart.voucher_amounts.credit.create!(
          amount:  amount,
          account: find_loan.receivable_account
        )
        find_cart.voucher_amounts.debit.create!(
          amount:  amount,
          account: find_share_capital.share_capital_equity_account
        )
      end

      def find_loan
        find_office.loans.find(loan_id)
      end

      def find_share_capital
        find_office.share_capitals.find(share_capital_id)
      end

      def find_office
        find_employee.office
      end

      def find_employee
        User.find(employee_id)
      end

      def find_cart
        find_employee.carts.find(cart_id)
      end
    end
  end
end
