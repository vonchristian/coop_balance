class CreateCooperatives < ActiveRecord::Migration[5.1]
  def change
    create_table :cooperatives, id: :uuid do |t|
      t.string :name
      t.string :registration_number

      t.timestamps
    end
  end
end
