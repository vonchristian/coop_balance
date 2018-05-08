class AddArchivedToLoans < ActiveRecord::Migration[5.2]
  def change
    add_column :loans, :archived, :boolean, default: false
  end
end
