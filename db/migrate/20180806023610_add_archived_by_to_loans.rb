class AddArchivedByToLoans < ActiveRecord::Migration[5.2]
  def change
    add_reference :loans, :archived_by, foreign_key: { to_table: :users }, type: :uuid
  end
end
