class AddBarangayToLoans < ActiveRecord::Migration[5.1]
  def change
    add_reference :loans, :barangay, foreign_key: true, type: :uuid
    add_reference :loans, :street, foreign_key: true, type: :uuid
    add_reference :loans, :municipality, foreign_key: true, type: :uuid
  end
end
