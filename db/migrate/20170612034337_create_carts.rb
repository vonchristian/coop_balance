class CreateCarts < ActiveRecord::Migration[5.1]
  def change
    create_table :carts, id: :uuid do |t|
      t.belongs_to :user, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
