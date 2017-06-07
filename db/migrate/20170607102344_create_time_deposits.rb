class CreateTimeDeposits < ActiveRecord::Migration[5.1]
  def change
    create_table :time_deposits, id: :uuid do |t|
      t.belongs_to :member, foreign_key: true, type: :uuid
      t.belongs_to :time_deposit_product, foreign_key: true, type: :uuid
      t.string :account_number

      t.timestamps
    end
    add_index :time_deposits, :account_number, unique: true
  end
end
