module SavingsAccounts
  class MultiplePayment
    include ActiveModel::Model
    attr_accessor :amount, :savings_account_id, :cart_id, :employee_id

    def process!
      return unless valid?

      ApplicationRecord.transaction do
        create_cart_amount
      end
    end

    private

    def create_cart_amount
      find_cart.voucher_amounts.credit.create!(
        cart_id: cart_id,
        amount: amount,
        account: find_savings_account.liability_account
      )
    end

    def find_cart
      StoreFrontModule::Cart.find(cart_id)
    end

    def find_savings_account
      find_office.savings.find(savings_account_id)
    end

    def find_office
      find_employee.office
    end

    def find_employee
      User.find(employee_id)
    end
  end
end