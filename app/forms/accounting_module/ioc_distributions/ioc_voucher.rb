module AccountingModule
  module IocDistributions
    class IocVoucher
      include ActiveModel::Model
      attr_accessor :date, :reference_number, :description, :cart_id, :employee_id, :account_number

      validates :date, :reference_number, :description, :cart_id, :employee_id, :account_number, presence: true

      def process!
        return unless valid?

        ApplicationRecord.transaction do
          create_voucher
          remove_cart_reference
        end
      end

      private

      def create_voucher
        voucher = find_office.vouchers.build(
          date: date,
          reference_number: reference_number,
          description: description,
          preparer: find_employee,
          cooperative: find_office.cooperative,
          payee: find_employee,
          account_number: account_number
        )
        voucher.voucher_amounts << find_cart.voucher_amounts.credit
        create_ioc_amount(voucher)
        voucher.save!
      end

      def create_ioc_amount(voucher)
        voucher.voucher_amounts.debit.build(amount: find_cart.voucher_amounts.credit.total,
                                            account: find_office.interest_on_capital_account)
      end

      def remove_cart_reference
        find_cart.voucher_amounts.each do |am|
          am.cart_id = nil
          am.save!
        end
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
