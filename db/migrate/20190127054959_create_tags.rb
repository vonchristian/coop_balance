class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags, id: :uuid do |t|
      t.string :name
      t.string :color

      t.timestamps
    end
  end
end
