class Remove2originFromEntries < ActiveRecord::Migration[7.1]
  def change
    remove_reference :entries, :origin, polymorphic: true, null: false
  end
end
