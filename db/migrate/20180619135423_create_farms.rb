class CreateFarms < ActiveRecord::Migration[5.2]
  def change
    create_table :farms, id: :uuid do |t|
      t.string :description
      t.belongs_to :barangay, foreign_key: true, type: :uuid
      t.decimal :area

      t.timestamps
    end
  end
end
