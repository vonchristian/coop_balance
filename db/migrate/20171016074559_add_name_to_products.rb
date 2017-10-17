class AddNameToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :name, :string
    add_index :products, :name, unique: true
  end
end
