class CreatePrograms < ActiveRecord::Migration[5.1]
  def change
    create_table :programs, id: :uuid do |t|
      t.string :name
      t.decimal :contribution
      t.boolean :default_program, default: false

      t.timestamps
    end
  end
end
