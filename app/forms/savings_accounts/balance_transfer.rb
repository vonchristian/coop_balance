module SavingsAccounts
  class BalanceTransfer
    include ActiveModel::Model
    attr_accessor :cart_id, :destination_savings_account_id, :amount, :employee_id

    def process!
      return unless valid?

      ApplicationRecord.transaction do
        create_voucher_amount
      end
    end

    private

    def create_voucher_amount
      find_cart.voucher_amounts.credit.create!(
        amount: amount,
        account: find_destination_saving.liability_account
      )
    end

    def find_cart
      StoreFrontModule::Cart.find(cart_id)
    end

    def find_destination_saving
      find_office.savings.find(destination_savings_account_id)
    end

    def find_office
      find_employee.office
    end

    def find_employee
      User.find(employee_id)
    end
  end
end
