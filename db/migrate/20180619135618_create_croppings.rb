class CreateCroppings < ActiveRecord::Migration[5.2]
  def change
    create_table :croppings, id: :uuid do |t|
      t.belongs_to :crop, foreign_key: true, type: :uuid
      t.datetime :date_started
      t.datetime :date_harvested
      t.decimal :harvest
      t.decimal :selling_price
      t.belongs_to :farm, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
