class CreateEntryClearances < ActiveRecord::Migration[5.1]
  def change
    create_table :entry_clearances, id: :uuid do |t|
      t.belongs_to :entry, foreign_key: true, type: :uuid
      t.datetime :clearance_date
      t.belongs_to :user, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
