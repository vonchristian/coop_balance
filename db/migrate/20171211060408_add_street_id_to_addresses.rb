class AddStreetIdToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_reference :addresses, :street, foreign_key: true, type: :uuid
    add_reference :addresses, :barangay, foreign_key: true, type: :uuid
    add_reference :addresses, :municipality, foreign_key: true, type: :uuid
  end
end
