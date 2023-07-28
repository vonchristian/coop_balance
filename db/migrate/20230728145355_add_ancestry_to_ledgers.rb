class AddAncestryToLedgers < ActiveRecord::Migration[6.1]
  def change
    change_table :ledgers do |t|
      # postgres
      t.string "ancestry", collation: 'C', null: false
      t.index "ancestry"
    end
  end
end
