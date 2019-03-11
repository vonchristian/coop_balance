class CreateDeactivations < ActiveRecord::Migration[5.2]
  def change
    create_table :deactivations, id: :uuid do |t|
      t.references :deactivatable, polymorphic: true, type: :uuid
      t.text :remarks
      t.datetime :deactivated_at
      t.boolean :active

      t.timestamps
    end
  end
end
