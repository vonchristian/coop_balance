class CreateIncomeSourceCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :income_source_categories, id: :uuid do |t|
      t.string :title

      t.timestamps
    end
    add_index :income_source_categories, :title, unique: true
  end
end
