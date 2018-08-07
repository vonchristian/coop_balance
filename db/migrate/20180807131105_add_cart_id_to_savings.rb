class AddCartIdToSavings < ActiveRecord::Migration[5.2]
  def change
    add_reference :savings, :cart, foreign_key: true, type: :uuid
  end
end
