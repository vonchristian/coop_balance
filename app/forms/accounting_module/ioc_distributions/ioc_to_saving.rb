module AccountingModule
  module IocDistributions
    class IocToSaving
      include ActiveModel::Model
      attr_accessor :saving_id, :cart_id, :employee_id, :amount

      validates :saving_id, :cart_id, :employee_id, :amount, presence: true
      validates :amount, numericality: { greater_than: 0 }

      def process!
        return unless valid?

        ApplicationRecord.transaction do
          create_cart_amount
        end
      end

      private

      def create_cart_amount
        find_cart.voucher_amounts.credit.create!(
          amount: amount.to_f,
          account: find_saving.liability_account
        )
      end

      def find_cart
        find_employee.carts.find(cart_id)
      end

      def find_employee
        User.find(employee_id)
      end

      def find_saving
        find_office.savings.find(saving_id)
      end

      def find_office
        find_employee.office
      end
    end
  end
end
