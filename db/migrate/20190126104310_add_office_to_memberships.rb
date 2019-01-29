class AddOfficeToMemberships < ActiveRecord::Migration[5.2]
  def change
    add_reference :memberships, :office, foreign_key: true, type: :uuid
  end
end
