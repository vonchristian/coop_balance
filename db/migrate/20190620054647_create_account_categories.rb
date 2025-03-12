class CreateAccountCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :account_categories, id: :uuid do |t|
      t.string :title
      t.belongs_to :cooperative, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
