class AddOfficeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :office, foreign_key: true, type: :uuid
  end
end
