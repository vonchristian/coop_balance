class CreateMembershipCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :membership_categories, id: :uuid do |t|
      t.string :title
      t.belongs_to :cooperative, null: false, foreign_key: true, type: :uuid 

      t.timestamps
    end
  end
end
