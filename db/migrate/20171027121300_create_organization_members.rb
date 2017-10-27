class CreateOrganizationMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :organization_members, id: :uuid do |t|
      t.belongs_to :member, foreign_key: true, type: :uuid
      t.belongs_to :organization, foreign_key: true, type: :uuid
      t.datetime :date

      t.timestamps
    end
  end
end
