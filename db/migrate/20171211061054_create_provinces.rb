class CreateProvinces < ActiveRecord::Migration[5.2]
  def change
    create_table :provinces, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
    add_index :provinces, :name, unique: true
  end
end
