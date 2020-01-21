module SavingsAccounts
  class MultiplePaymentVoucherProcessing 
    include ActiveModel::Model
    attr_accessor :cart_id, :date, :reference_number, :description, :employee_id, :cash_account_id, :account_number
    
    validates :cart_id, :date, :reference_number, :description, :employee_id, :cash_account_id, :account_number, presence: true
   
    def find_voucher
      find_office.vouchers.find_by(account_number: account_number)
    end 

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
        description:      description,
        reference_number: reference_number,
        account_number:   account_number,
        preparer:         find_employee,
        cooperative:      find_employee.cooperative,
        payee:            find_employee
      )
      voucher.voucher_amounts << find_cart.voucher_amounts.credit 
      
      voucher.voucher_amounts.debit.build(
        amount:     find_cart.voucher_amounts.credit.total,
        account_id: cash_account_id)
      
        voucher.save!
    end 

    def remove_cart_reference
      find_voucher.voucher_amounts.each do |amount|
        amount.update!(cart_id: nil)
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