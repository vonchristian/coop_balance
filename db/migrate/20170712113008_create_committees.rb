class CreateCommittees < ActiveRecord::Migration[5.1]
  def change
    create_table :committees, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
    add_index :committees, :name, unique: true
  end
end
