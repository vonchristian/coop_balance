class RemoveCodeFromMembers < ActiveRecord::Migration[6.0]
  def change
    remove_column :members, :code, :string
  end
end
