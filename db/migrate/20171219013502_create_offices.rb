class CreateOffices < ActiveRecord::Migration[5.1]
  def change
    create_table :offices, id: :uuid do |t|
      t.string :type
      t.string :name
      t.belongs_to :cooperative, foreign_key: true, type: :uuid
      t.string :address
      t.string :contact_number

      t.timestamps
    end
    add_index :offices, :type
  end
end
