class AddOrganizationToLoans < ActiveRecord::Migration[5.1]
  def change
    add_reference :loans, :organization, foreign_key: true, type: :uuid
  end
end
