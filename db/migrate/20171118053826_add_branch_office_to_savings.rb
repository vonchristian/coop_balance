class AddBranchOfficeToSavings < ActiveRecord::Migration[5.1]
  def change
    add_reference :savings, :branch_office, foreign_key: true, type: :uuid
  end
end
