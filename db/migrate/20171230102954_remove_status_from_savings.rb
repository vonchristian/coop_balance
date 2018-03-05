class RemoveStatusFromSavings < ActiveRecord::Migration[5.1]
  def change
    remove_column :savings, :status, :integer
  end
end
