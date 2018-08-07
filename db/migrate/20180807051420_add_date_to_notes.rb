class AddDateToNotes < ActiveRecord::Migration[5.2]
  def change
    add_column :notes, :date, :datetime
  end
end
