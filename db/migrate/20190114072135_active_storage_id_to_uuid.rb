class ActiveStorageIdToUuid < ActiveRecord::Migration[5.2]
	require 'webdack/uuid_migration/helpers'

  def change
  	reversible do |dir|
  		dir.up do
  			primary_key_to_uuid :active_storage_attachments
  			primary_key_to_uuid :active_storage_blobs
  		end

  		dir.down do
  			raise ActiveRecord::IrreversibleMigration
  		end
  	end
  end
end
