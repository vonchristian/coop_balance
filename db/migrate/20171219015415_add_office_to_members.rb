class AddOfficeToMembers < ActiveRecord::Migration[5.1]
  def change
    add_reference :members, :office, foreign_key: true, type: :uuid
  end
end
