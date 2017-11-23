class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes, id: :uuid do |t|
      t.references :noteable, polymorphic: true, type: :uuid
      t.belongs_to :noter, foreign_key: { to_table: :users }, type: :uuid
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
