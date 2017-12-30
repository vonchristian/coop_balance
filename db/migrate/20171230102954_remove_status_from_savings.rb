class RemoveStatusFromSavings < ActiveRecord::Migration[5.2]
  def change
    remove_column :savings, :status, :integer
  end
end
