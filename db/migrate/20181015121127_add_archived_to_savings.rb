class AddArchivedToSavings < ActiveRecord::Migration[5.2]
  def change
    add_column :savings, :archived, :boolean
    add_column :savings, :archived_at, :datetime
  end
end
