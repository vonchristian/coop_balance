class RemoveDiscountableFromLoanDiscounts < ActiveRecord::Migration[6.0]
  def change
    remove_reference :loan_discounts, :discountable, polymorphic: true, null: false, type: :uuid
  end
end
