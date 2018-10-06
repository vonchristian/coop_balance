class RemoveTypeFromShareCapitals < ActiveRecord::Migration[5.2]
  def change
    remove_index :share_capitals, :type
    remove_column :share_capitals, :type, :string
  end
end
