class CreateTins < ActiveRecord::Migration[5.1]
  def change
    create_table :tins, id: :uuid do |t|
      t.string :number
      t.references :tinable, polymorphic: true, type: :uuid

      t.timestamps
    end
  end
end
