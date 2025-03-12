class AddOfficeTypeToOffices < ActiveRecord::Migration[7.2]
  def change
    add_column :offices, :office_type, :string
    add_index :offices, :office_type
  end
end
