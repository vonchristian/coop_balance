module LoansModule
  module Loans
    class PaymentFromSavingVoucher
      include ActiveModel::Model

      attr_accessor :date, :description, :reference_number, :loan_id, :cart_id, :employee_id, :account_number

      validates :loan_id, :date, :description, :reference_number, :loan_id, :cart_id, :employee_id, :account_number, presence: true

      def process!
        if valid?
          ApplicationRecord.transaction do
            create_voucher
          end
        end
      end

      private
      def create_voucher
        voucher = find_office.vouchers.build(
          cooperative:      find_office.cooperative,
          date:             date,
          payee:            find_loan.borrower,
          description:      description,
          account_number:   account_number,
          reference_number: reference_number,
          preparer:         find_employee
        )

        voucher.voucher_amounts << find_cart.voucher_amounts
        voucher.save!
      end

      def find_office
        find_employee.office
      end

      def find_employee
        User.find(employee_id)
      end

      def find_loan
        find_office.loans.find(loan_id)
      end

      def find_cart
        find_employee.carts.find(cart_id)
      end
    end
  end
end
