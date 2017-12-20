class CreateEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :entries, id: :uuid do |t|
      t.string :reference_number
      t.datetime :entry_date, index: true
      t.references :commercial_document, polymorphic: true,  type: :uuid, index: {name: "index_on_commercial_document_entry" }
      t.belongs_to :recorder, foreign_key: { to_table: :users }, type: :uuid
      t.string :description
      t.timestamps
    end
  end
end
