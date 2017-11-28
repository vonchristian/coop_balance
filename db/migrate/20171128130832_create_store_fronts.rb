class CreateStoreFronts < ActiveRecord::Migration[5.1]
  def change
    create_table :store_fronts, id: :uuid do |t|
      t.belongs_to :cooperative, foreign_key: true, type: :uuid
      t.string :name
      t.string :address
      t.string :contact_number

      t.timestamps
    end
  end
end
