class AddCartToCashCounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :cash_counts, :cart, foreign_key: true, type: :uuid
  end
end
