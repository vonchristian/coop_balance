class RemoveBranchOfficeFromMembers < ActiveRecord::Migration[5.2]
  def change
    remove_reference :members, :branch_office, foreign_key: true, type: :uuid
  end
end
