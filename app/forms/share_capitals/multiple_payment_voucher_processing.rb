module ShareCapitals
  class MultiplePaymentVoucherProcessing 
    include ActiveModel::Model
    attr_accessor :cart_id, :date, :reference_number, :description, :employee_id, :cash_account_id, :account_number

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
        date: date, 
        description: description,
        reference_number: reference_number,
        account_number: account_number,
        preparer: find_employee,
        cooperative: find_employee.cooperative,
        payee: find_employee
      )
      voucher.voucher_amounts << find_cart.voucher_amounts.credit 
      voucher.voucher_amounts.debit.build(
        amount: find_cart.voucher_amounts.credit.total,
        account_id: cash_account_id
      )
      voucher.save!

      find_cart.voucher_amounts.each do |amount|
        amount.cart_id = nil 
        amount.save!
      end 
    end 

    def find_office 
      find_employee.office 
    end 

    def find_employee
      User.find(employee_id)
    end 

    def find_cart
      StoreFrontModule::Cart.find(cart_id)
    end 
  end 
end 