class CreateOccupations < ActiveRecord::Migration[5.1]
  def change
    create_table :occupations, id: :uuid do |t|
      t.string :title

      t.timestamps
    end
  end
end
