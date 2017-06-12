class AddDepartmentToEntries < ActiveRecord::Migration[5.1]
  def change
    add_reference :entries, :department, foreign_key: true, type: :uuid
  end
end
