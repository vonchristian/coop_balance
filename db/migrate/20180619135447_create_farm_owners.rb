class CreateFarmOwners < ActiveRecord::Migration[5.2]
  def change
    create_table :farm_owners, id: :uuid do |t|
      t.belongs_to :farm, foreign_key: true, type: :uuid
      t.references :owner, polymorphic: true, type: :uuid

      t.timestamps
    end
  end
end
