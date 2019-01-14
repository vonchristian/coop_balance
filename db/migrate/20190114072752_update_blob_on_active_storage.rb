class UpdateBlobOnActiveStorage < ActiveRecord::Migration[5.2]
  def change
  	remove_reference :active_storage_attachments, :blob
  	add_reference    :active_storage_attachments, :blob, type: :uuid
  end
end
