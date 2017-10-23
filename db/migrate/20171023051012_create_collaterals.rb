class CreateCollaterals < ActiveRecord::Migration[5.1]
  def change
    create_table :collaterals, id: :uuid do |t|
      t.belongs_to :loan, foreign_key: true, type: :uuid
      t.belongs_to :real_property, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
