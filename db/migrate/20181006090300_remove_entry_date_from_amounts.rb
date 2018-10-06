class RemoveEntryDateFromAmounts < ActiveRecord::Migration[5.2]
  def change
    remove_column :amounts, :entry_date, :datetime
  end
end
