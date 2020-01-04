class CreateAccountScopes < ActiveRecord::Migration[6.0]
  def change
    create_table :account_scopes, id: :uuid do |t|
      t.references :scopeable, polymorphic: true, null: false, type: :uuid
      t.references :account, polymorphic: true, null: false, type: :uuid

      t.timestamps
    end
  end
end
