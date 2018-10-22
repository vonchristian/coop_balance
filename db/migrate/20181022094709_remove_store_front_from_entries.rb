class RemoveStoreFrontFromEntries < ActiveRecord::Migration[5.2]
  def change
    remove_reference :entries, :store_front, foreign_key: true, type: :uuid
  end
end
