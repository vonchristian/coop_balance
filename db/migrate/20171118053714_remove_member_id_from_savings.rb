class RemoveMemberIdFromSavings < ActiveRecord::Migration[5.1]
  def change
    remove_reference :savings, :member, foreign_key: true
  end
end
