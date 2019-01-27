class CreateTaggings < ActiveRecord::Migration[5.2]
  def change
    create_table :taggings, id: :uuid do |t|
      t.belongs_to :tag, foreign_key: true, type: :uuid
      t.references :taggable, polymorphic: true, type: :uuid

      t.timestamps
    end
  end
end
