class AddCartToMembers < ActiveRecord::Migration[5.2]
  def change
    add_reference :members, :cart, foreign_key: true, type: :uuid
  end
end
