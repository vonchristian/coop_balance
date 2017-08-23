class CreateMemberships < ActiveRecord::Migration[5.1]
  def change
    create_table :memberships, id: :uuid do |t|
      t.references :memberable, polymorphic: true, type: :uuid
      t.datetime :membership_date
      t.belongs_to :cooperative, foreign_key: true, type: :uuid
      t.integer :membership_type, index: true

      t.timestamps
    end
  end
end
