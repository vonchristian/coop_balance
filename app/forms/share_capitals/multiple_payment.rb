module ShareCapitals 
  class MultiplePayment 
    include ActiveModel::Model 
    attr_accessor :amount, :share_capital_id, :cart_id, :employee_id
    
    validates :amount, :share_capital_id, :cart_id, :employee_id, presence: true
    validates :amount, numericality: { greater_than: 0 }
   
    def process!
      if valid?
        ApplicationRecord.transaction do 
          create_cart_amount 
        end 
      end 
    end 

    private 

    def create_cart_amount
      find_cart.voucher_amounts.credit.create!(
      amount:  amount, 
      account: find_share_capital.share_capital_equity_account)
    end 

    def find_cart 
      find_employee.carts.find(cart_id)
    end 

    def find_share_capital
      find_office.share_capitals.find(share_capital_id)
    end 

    def find_office
      find_employee.office 
    end 

    def find_employee
      User.find(employee_id)
    end 
  end 
end 