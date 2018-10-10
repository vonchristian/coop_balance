class AddAbbreviatedNameToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :abbreviated_name, :string
  end
end
