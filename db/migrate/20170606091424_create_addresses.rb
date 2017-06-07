class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses, id: :uuid do |t|
      t.string :street
      t.string :barangay
      t.string :municipality
      t.string :province
      t.references :addressable, polymorphic: true, type: :uuid, index: true

      t.timestamps
    end
  end
end
