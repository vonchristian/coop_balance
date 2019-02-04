class CreateArchives < ActiveRecord::Migration[5.2]
  def change
    create_table :archives, id: :uuid do |t|
      t.references :record, polymorphic: true, type: :uuid
      t.belongs_to :archiver, foreign_key: { to_table: :users }, type: :uuid
      t.datetime :archived_at
      t.string :remarks

      t.timestamps
    end
  end
end
