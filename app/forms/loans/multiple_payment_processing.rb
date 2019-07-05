module Loans
  class MultiplePaymentProcessing
    include ActiveModel::Model
    attr_accessor :date, :reference_number, :description, :account_number, :cart_id, :employee_id
    validates :date, :reference_number, :description, presence: true
    def find_voucher
      find_office.vouchers.find_by(account_number: account_number)
    end

    def create_voucher!
      voucher = find_office.vouchers.create!(
        date: date,
        reference_number: reference_number,
        description: description,
        account_number: account_number,
        office: find_office,
        preparer: find_employee,
        payee: find_employee,
        cooperative: find_office.cooperative
      )
      find_cart.voucher_amounts.each do |voucher_amount|
        voucher_amount.voucher_id = voucher.id
        voucher_amount.cart_id = nil
        voucher_amount.save!
      end
    end
    def find_office
      find_employee.office
    end
    def find_cart
      StoreFrontModule::Cart.find(cart_id)
    end
    def find_employee
      User.find(employee_id)
    end
  end
end