class CreateMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :menus, id: :uuid do |t|
      t.string :name
      t.string :description
      t.string :unit

      t.timestamps
    end
    add_index :menus, :name, unique: true
  end
end
