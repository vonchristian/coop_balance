class RemoveCartFromSavings < ActiveRecord::Migration[5.2]
  def change
    remove_reference :savings, :cart, foreign_key: true, type: :uuid
  end
end
