class CreateAccountableAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accountable_accounts, id: :uuid do |t|
      t.references :accountable, polymorphic: true, type: :uuid, index: { name: "index_accountable_on_accountable_accounts" }
      t.belongs_to :account, foreign_key: true, type: :uuid
    end
  end
end
