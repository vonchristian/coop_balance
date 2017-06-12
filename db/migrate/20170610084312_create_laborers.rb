class CreateLaborers < ActiveRecord::Migration[5.1]
  def change
    create_table :laborers, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.decimal :daily_rate

      t.timestamps
    end
  end
end
