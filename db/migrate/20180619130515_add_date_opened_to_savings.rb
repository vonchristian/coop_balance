class AddDateOpenedToSavings < ActiveRecord::Migration[5.2]
  def change
    add_column :savings, :date_opened, :datetime
  end
end
