class AddDiscountableToLoanDiscounts < ActiveRecord::Migration[6.0]
  def change
    add_reference :loan_discounts, :discountable, polymorphic: true, null: false, type: :uuid 
  end
end
