class RemoveIndexOfNameOnSavingProducts < ActiveRecord::Migration[5.2]
  def up
    remove_index(:saving_products, name: 'index_saving_products_on_name')
  end
  def down
    add_index(:saving_products, name: 'index_saving_products_on_name')
  end
end
