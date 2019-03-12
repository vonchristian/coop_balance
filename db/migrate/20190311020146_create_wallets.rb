class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets, id: :uuid do |t|
      t.references :account_owner, polymorphic: true, type: :uuid
      t.belongs_to :account, foreign_key: true, type: :uuid
      t.string :account_number

      t.timestamps
    end
    add_index :wallets, :account_number, unique: true
  end
end
