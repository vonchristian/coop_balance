class CreateOrganizationScopes < ActiveRecord::Migration[6.0]
  def change
    create_table :organization_scopes, id: :uuid do |t|
      t.belongs_to :organization, null: false, foreign_key: true, type: :uuid 
      t.references :account, polymorphic: true, null: false, type: :uuid 

      t.timestamps
    end
  end
end
