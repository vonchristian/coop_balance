class CreateLevelTwoAccountCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :level_two_account_categories, id: :uuid do |t|
      t.string :title
      t.belongs_to :office, foreign_key: true, type: :uuid 
      t.string :code
      t.string :type
      t.boolean :contra

      t.timestamps
    end
    add_index :level_two_account_categories, :type
  end
end
