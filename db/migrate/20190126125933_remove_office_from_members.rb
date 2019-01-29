class RemoveOfficeFromMembers < ActiveRecord::Migration[5.2]
  def change
    remove_reference :members, :office, foreign_key: true, type: :uuid
  end
end
