class CreateIdentityProviders < ActiveRecord::Migration[5.2]
  def change
    create_table :identity_providers, id: :uuid do |t|
      t.string :name
      t.string :account_number, unique: true
      t.timestamps
    end
  end
end
