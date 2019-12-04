class CreateRegistries < ActiveRecord::Migration[5.1]
  def change
    create_table :registries, id: :uuid do |t|
      t.datetime :date
      t.string :type, index: true

      t.timestamps
    end
  end
end
