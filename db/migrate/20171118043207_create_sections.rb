class CreateSections < ActiveRecord::Migration[5.1]
  def change
    create_table :sections, id: :uuid do |t|
      t.belongs_to :branch_office, foreign_key: true, type: :uuid
      t.string :name
      t.string :description

      t.timestamps
    end
    add_index :sections, :name, unique: true
  end
end
