class AddDateOfBirthToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :date_or_birth, :date
    add_column :users, :birth_month, :integer
    add_column :users, :birth_day, :integer
  end
end
