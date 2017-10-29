class AddStatusToShareCapitals < ActiveRecord::Migration[5.1]
  def change
    add_column :share_capitals, :status, :integer
    add_index :share_capitals, :status
  end
end
