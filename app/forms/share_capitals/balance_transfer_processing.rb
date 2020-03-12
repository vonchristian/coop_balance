module ShareCapitals
  class BalanceTransferProcessing
    include ActiveModel::Model

    attr_accessor :origin_share_capital_id, :destination_share_capital_id, :amount, :cart_id, :employee_id

    validates :amount, presence: true, numericality: true
    validates :origin_share_capital_id, :destination_share_capital_id, :cart_id, :employee_id, presence: true

    def process!
      if valid?
        ActiveRecord::Base.transaction do
          create_voucher_amount
        end
      end 
    end

    private

    def create_voucher_amount
      find_cart.voucher_amounts.credit.create!(amount: amount, account: find_destination_share_capital.share_capital_equity_account)
      find_cart.voucher_amounts.debit.create!(amount: amount, account: find_origin_share_capital.share_capital_equity_account)
    end

    def find_cart
      find_employee.carts.find(cart_id)
    end
    def find_employee
      User.find(employee_id)
    end

    def find_office
      find_employee.office
    end

    def find_origin_share_capital
      find_office.share_capitals.find(origin_share_capital_id)
    end

    def find_destination_share_capital
      find_office.share_capitals.find(destination_share_capital_id)
    end
  end
end
