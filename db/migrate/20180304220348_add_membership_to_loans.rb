class AddMembershipToLoans < ActiveRecord::Migration[5.1]
  def change
    add_reference :loans, :membership, foreign_key: true, type: :uuid
  end
end
