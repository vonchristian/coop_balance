class IdToUuidActiveStorageReference < ActiveRecord::Migration[5.2]
  def change
  	remove_reference :active_storage_attachments, :record, polymorphic: true
  	add_reference    :active_storage_attachments, :record, polymorphic: true, type: :uuid
  end
end
