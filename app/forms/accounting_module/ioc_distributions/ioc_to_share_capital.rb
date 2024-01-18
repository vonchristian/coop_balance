module AccountingModule
  module IocDistributions
    class IocToShareCapital
      include ActiveModel::Model
      attr_accessor :share_capital_id, :cart_id, :employee_id, :amount

      validates :share_capital_id, :cart_id, :employee_id, :amount, presence: true
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
          account: find_share_capital.share_capital_equity_account
        )
      end

      def find_cart
        find_employee.carts.find(cart_id)
      end

      def find_employee
        User.find(employee_id)
      end

      def find_share_capital
        find_office.share_capitals.find(share_capital_id)
      end

      def find_office
        find_employee.office
      end
    end
  end
end