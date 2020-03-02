class CreateIncomeSources < ActiveRecord::Migration[6.0]
  def change
    create_table :income_sources, id: :uuid do |t|
      t.string :designation
      t.string :description
      t.decimal :monthly_income
      t.belongs_to :income_source_category, null: false, foreign_key: true, type: :uuid 
      t.belongs_to :member, null: false, foreign_key: true, type: :uuid 

      t.timestamps
    end
  end
end
