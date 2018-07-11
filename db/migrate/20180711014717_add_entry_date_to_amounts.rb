class AddEntryDateToAmounts < ActiveRecord::Migration[5.2]
  def change
    add_column :amounts, :entry_date, :datetime
  end
end
