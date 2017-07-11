class AddUserToCarts < ActiveRecord::Migration[5.1]
  def change
    add_reference :carts, :user, foreign_key: true, type: :uuid
  end
end
