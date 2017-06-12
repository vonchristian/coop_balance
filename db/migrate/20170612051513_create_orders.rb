class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders, id: :uuid do |t|
      t.belongs_to :member, foreign_key: true, type: :uuid
      t.datetime :date

      t.timestamps
    end
  end
end
