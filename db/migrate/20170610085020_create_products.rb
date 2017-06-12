class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products, id: :uuid do |t|
      t.string :name
      t.string :description
      t.string :unit

      t.timestamps
    end
    add_index :products, :name, unique: true
  end
end
