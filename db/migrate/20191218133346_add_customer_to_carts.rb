class AddCustomerToCarts < ActiveRecord::Migration[6.0]
  def change
    add_reference :carts, :customer, polymorphic: true, type: :uuid
  end
end
