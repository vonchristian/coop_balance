class RemoveMemberFromLoans < ActiveRecord::Migration[5.1]
  def up
    remove_reference :loans, :member, foreign_key: true, type: :uuid
  end
  def down
    add_reference :loans, :member, foreign_key: true, type: :uuid
  end
end
