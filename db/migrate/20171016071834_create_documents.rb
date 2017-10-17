class CreateDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :documents, id: :uuid do |t|
      t.string :name
      t.text :title
      t.datetime :date
      t.references :uploader, polymorphic: true,  type: :uuid, index: true
      t.timestamps
    end
  end
end
