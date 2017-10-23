class AddBirthMonthToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :birth_month, :integer
    add_column :members, :birth_day, :integer
  end
end
