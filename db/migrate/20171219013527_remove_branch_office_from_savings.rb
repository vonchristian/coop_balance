class RemoveBranchOfficeFromSavings < ActiveRecord::Migration[5.2]
  def change
    remove_reference :savings, :branch_office, foreign_key: true
  end
end
