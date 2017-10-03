class AddCivilStatusToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :civil_status, :integer
  end
end
