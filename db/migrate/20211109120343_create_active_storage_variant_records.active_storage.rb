# This migration comes from active_storage (originally 20191206030411)
class CreateActiveStorageVariantRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :active_storage_variant_record, id: :uuid do |t|
      t.references :blob, null: false, index: false, type: :uuid
      t.string :variation_digest, null: false

      t.index %i[ blob_id variation_digest ], name: "index_active_storage_variant_records_uniqueness", unique: true
    end
  end
end
