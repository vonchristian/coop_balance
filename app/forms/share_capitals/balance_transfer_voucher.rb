module ShareCapitals
  class BalanceTransferVoucher
    include ActiveModel::Model
    attr_accessor :cart_id, :date, :reference_number, :description, :employee_id, :account_number, :share_capital_id
    def process!
      if valid?
        ApplicationRecord.transaction do
          create_voucher
          remove_cart_reference
        end
      end
    end

    private
    def create_voucher
      voucher = find_office.vouchers.build(
        date:             date,
        reference_number: reference_number,
        description:      description,
        account_number:   account_number,
        preparer:         find_employee,
        cooperative:      find_employee.cooperative,
        payee:            find_share_capital.subscriber
      )
      voucher.voucher_amounts << find_cart.voucher_amounts
      voucher.save!

    end
    
    def find_employee
      User.find(employee_id)
    end

    def find_office
      find_employee.office
    end

    def find_cart
      find_employee.carts.find(cart_id)
    end

    def find_share_capital
      find_office.share_capitals.find(share_capital_id)
    end

    def remove_cart_reference
      find_cart.voucher_amounts.each do |amount|
        amount.cart_id = nil 
        amount.save
      end
    end
  end
end
