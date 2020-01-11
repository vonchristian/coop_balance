class CreateSavingsAgingGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :savings_aging_groups, id: :uuid do |t|
      t.belongs_to :office, null: false, foreign_key: true, type: :uuid 
      t.integer :start_num, null: false 
      t.integer :end_num, null: false 
      t.string :title, null: false 
      t.timestamps
    end
  end
end
