class AddOriginToEntries < ActiveRecord::Migration[5.1]
  def change
    add_reference :entries, :origin, polymorphic: true, type: :uuid
  end
end
