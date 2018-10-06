class RemoveOriginFromEntries < ActiveRecord::Migration[5.2]
  def change
    remove_reference :entries, :origin, polymorphic: true, type: :uuid
  end
end
