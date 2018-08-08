class AddBarangayAgainToShareCapitals < ActiveRecord::Migration[5.2]
  def change
    add_reference :share_capitals, :barangay, foreign_key: true, type: :uuid
    add_reference :share_capitals, :organization, foreign_key: true, type: :uuid
  end
end
