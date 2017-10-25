class AddStatusToSavings < ActiveRecord::Migration[5.1]
  def change
    add_column :savings, :status, :integer
  end
end
