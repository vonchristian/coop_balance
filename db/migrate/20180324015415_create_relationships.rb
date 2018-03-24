class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships, id: :uuid do |t|
      t.integer :relationship_type
      t.references :relationee, polymorphic: true,  type: :uuid
      t.references :relationer, polymorphic: true,  type: :uuid
      t.timestamps
    end
    add_index :relationships, :relationship_type
  end
end
