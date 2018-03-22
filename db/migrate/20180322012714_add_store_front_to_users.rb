class AddStoreFrontToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :store_front, foreign_key: true, type: :uuid
  end
end
