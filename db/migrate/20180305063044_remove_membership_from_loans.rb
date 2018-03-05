class RemoveMembershipFromLoans < ActiveRecord::Migration[5.2]
  def change
    remove_reference :loans, :membership, foreign_key: true, type: :uuid
  end
end
