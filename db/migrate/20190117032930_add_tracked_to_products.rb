class AddTrackedToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :tracked, :boolean, default: false
  end
end
