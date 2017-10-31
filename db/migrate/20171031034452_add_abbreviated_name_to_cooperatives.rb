class AddAbbreviatedNameToCooperatives < ActiveRecord::Migration[5.1]
  def change
    add_column :cooperatives, :abbreviated_name, :string
    add_index :cooperatives, :abbreviated_name, unique: true
  end
end
