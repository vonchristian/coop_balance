class AddBranchOfficeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :branch_office, foreign_key: true, type: :uuid
  end
end
