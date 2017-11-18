class AddBranchOfficeIdToMembers < ActiveRecord::Migration[5.1]
  def change
    add_reference :members, :branch_office, foreign_key: true, type: :uuid
  end
end
