module AccountingModule
  module Entries
    class VoucherAmountProcessing
      include ActiveModel::Model
      attr_accessor :account_id, :amount, :amount_type, :employee_id, :cart_id
      validates :account_id, :cart_id, :amount_type, :employee_id, presence: true
      def process!
        ActiveRecord::Base.transaction do
          create_voucher_amount
        end
      end

      private
      def create_voucher_amount
        find_cart.voucher_amounts.create!(
          cooperative: find_employee.cooperative,
          amount_type: amount_type,
          account_id:  account_id,
          amount:      amount,
          recorder:    find_employee
        )
      end

      def find_employee
        User.find(employee_id)
      end
      def find_cart
        StoreFrontModule::Cart.find(cart_id)
      end
    end
  end
end
