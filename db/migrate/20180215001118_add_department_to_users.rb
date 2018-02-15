class AddDepartmentToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :department, foreign_key: true, type: :uuid
  end
end
