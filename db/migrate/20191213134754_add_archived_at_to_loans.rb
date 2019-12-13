class AddArchivedAtToLoans < ActiveRecord::Migration[6.0]
  def change
    add_column :loans, :date_archived, :datetime
  end
end
