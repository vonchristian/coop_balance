class AddOrigin2ToEntries < ActiveRecord::Migration[6.0]
  def change
    add_reference :entries, :origin, polymorphic: true, type: :uuid
  end
end
