class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts, id: :uuid do |t|
      t.references :contactable, polymorphic: true, type: :uuid
      t.string :number

      t.timestamps
    end
  end
end
