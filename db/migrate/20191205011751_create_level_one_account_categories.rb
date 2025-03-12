class CreateLevelOneAccountCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :level_one_account_categories, id: :uuid do |t|
      t.belongs_to :office, foreign_key: true, type: :uuid
      t.string :title
      t.string :code
      t.boolean :contra
      t.string :type

      t.timestamps
    end
    add_index :level_one_account_categories, :type
  end
end
