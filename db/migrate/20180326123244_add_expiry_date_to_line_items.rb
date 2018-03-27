class AddExpiryDateToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_column :line_items, :expiry_date, :datetime
  end
end
