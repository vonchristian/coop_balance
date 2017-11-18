class AddBranchOfficeIdToEntries < ActiveRecord::Migration[5.1]
  def change
    add_reference :entries, :branch_office, foreign_key: true, type: :uuid
  end
end
