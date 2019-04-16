class AddCodeToSavings < ActiveRecord::Migration[5.2]
  def change
    add_column :savings, :code, :string
    add_index :savings, :code, unique: true
  end
end
