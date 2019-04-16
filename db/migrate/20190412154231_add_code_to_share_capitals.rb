class AddCodeToShareCapitals < ActiveRecord::Migration[5.2]
  def change
    add_column :share_capitals, :code, :string
    add_index :share_capitals, :code, unique: true
  end
end
