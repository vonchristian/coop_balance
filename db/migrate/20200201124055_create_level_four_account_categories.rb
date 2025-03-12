class CreateLevelFourAccountCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :level_four_account_categories, id: :uuid do |t|
      t.string :title
      t.belongs_to :office, null: false, foreign_key: true, type: :uuid
      t.string :code
      t.string :type
      t.boolean :contra, default: false

      t.timestamps
    end
    add_index :level_four_account_categories, :type
  end
end
