class AddStoreFrontToEntries < ActiveRecord::Migration[5.1]
  def change
    add_reference :entries, :store_front, foreign_key: true, type: :uuid
  end
end
