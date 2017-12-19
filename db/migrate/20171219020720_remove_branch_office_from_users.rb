class RemoveBranchOfficeFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_reference :users, :branch_office, foreign_key: true, type: :uuid
  end
end
