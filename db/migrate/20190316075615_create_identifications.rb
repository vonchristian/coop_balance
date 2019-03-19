class CreateIdentifications < ActiveRecord::Migration[5.2]
  def change
    create_table :identifications, id: :uuid do |t|
      t.references :identifiable, polymorphic: true, type: :uuid
      t.belongs_to :identity_provider, foreign_key: true, type: :uuid
      t.string :number
      t.datetime :issuance_date
      t.datetime :expiry_date

      t.timestamps
    end
  end
end
