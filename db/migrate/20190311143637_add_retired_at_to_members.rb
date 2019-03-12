class AddRetiredAtToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :retired_at, :datetime
  end
end
