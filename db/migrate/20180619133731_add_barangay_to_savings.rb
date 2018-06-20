class AddBarangayToSavings < ActiveRecord::Migration[5.2]
  def change
    add_reference :savings, :barangay, foreign_key: true, type: :uuid
  end
end
