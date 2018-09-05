class AddDesignationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :designation, :string
  end
end
