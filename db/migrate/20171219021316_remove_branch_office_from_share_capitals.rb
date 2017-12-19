class RemoveBranchOfficeFromShareCapitals < ActiveRecord::Migration[5.2]
  def change
    remove_reference :share_capitals, :branch_office, foreign_key: true, type: :uuid
  end
end
