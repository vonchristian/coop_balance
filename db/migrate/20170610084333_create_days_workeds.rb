class CreateDaysWorkeds < ActiveRecord::Migration[5.1]
  def change
    create_table :days_workeds, id: :uuid do |t|
      t.decimal :number_of_days
      t.belongs_to :laborer, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
