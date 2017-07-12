class AddCommitteeToCommitteeMembers < ActiveRecord::Migration[5.1]
  def change
    add_reference :committee_members, :committee, foreign_key: true, type: :uuid
  end
end
