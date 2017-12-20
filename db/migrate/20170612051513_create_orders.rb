class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders, id: :uuid do |t|
      t.belongs_to :member, foreign_key: true, type: :uuid
      t.belongs_to :user, foreign_key: true, type: :uuid

      t.datetime :date
      t.integer :pay_type, default: 0, index: true

      t.timestamps
    end
  end
end
