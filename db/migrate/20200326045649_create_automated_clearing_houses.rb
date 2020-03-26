class CreateAutomatedClearingHouses < ActiveRecord::Migration[6.0]
  def change
    create_table :automated_clearing_houses, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
  end
end
