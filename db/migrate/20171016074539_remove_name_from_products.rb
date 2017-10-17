class RemoveNameFromProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :name, :string
  end
end
