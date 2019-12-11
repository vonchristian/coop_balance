class CreateLevelThreeAccountCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :level_three_account_categories, id: :uuid do |t|
      t.string :title, null: false
      t.string :code, null: false
      t.belongs_to :office, null: false, foreign_key: true, type: :uuid
      t.boolean :contra, default: false
      t.string :type, null: false

      t.timestamps
    end
    add_index :level_three_account_categories, :type
  end
end
