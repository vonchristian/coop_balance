class CreateMerchants < ActiveRecord::Migration[5.2]
  def change
    create_table :merchants, id: :uuid do |t|
      t.string :name
      t.belongs_to :cooperative, foreign_key: true, type: :uuid
      t.belongs_to :liability_account, foreign_key: { to_table: :accounts }, type: :uuid

      t.timestamps
    end
  end
end
