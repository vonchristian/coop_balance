class CreateCarts < ActiveRecord::Migration[5.1]
  def change
    create_table :carts, id: :uuid do |t|

      t.timestamps
    end
  end
end
