class AddClosedAtToSavings < ActiveRecord::Migration[6.0]
  def change
    add_column :savings, :closed_at, :datetime
  end
end
