class AddBranchOfficeIdToShareCapitals < ActiveRecord::Migration[5.1]
  def change
    add_reference :share_capitals, :branch_office, foreign_key: true, type: :uuid
  end
end
