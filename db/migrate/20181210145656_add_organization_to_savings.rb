class AddOrganizationToSavings < ActiveRecord::Migration[5.2]
  def change
    add_reference :savings, :organization, foreign_key: true, type: :uuid
  end
end
