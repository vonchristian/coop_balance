class AddAbbreviatedNameToIdentityProviders < ActiveRecord::Migration[5.2]
  def change
    add_column :identity_providers, :abbreviated_name, :string
    add_index :identity_providers, :abbreviated_name, unique: true
  end
end
