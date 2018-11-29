class CreateOwnerships < ActiveRecord::Migration[5.2]
  def change
    create_table :ownerships, id: :uuid do |t|
      t.references :owner, polymorphic: true, type: :uuid
      t.references :ownable, polymorphic: true, type: :uuid

      t.timestamps
    end
  end
end
