class AddPreviousIdentificationToIdentifications < ActiveRecord::Migration[5.2]
  def change
    add_reference :identifications, :previous_identification, foreign_key: { to_table: :identifications }, type: :uuid
    add_column :identifications, :previous_id_hash, :string
    add_index :identifications, :previous_id_hash, unique: true
    add_column :identifications, :encrypted_hash, :string
    add_index :identifications, :encrypted_hash, unique: true
  end
end
