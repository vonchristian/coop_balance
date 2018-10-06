class RemoveRecorderFromAmounts < ActiveRecord::Migration[5.2]
  def change
    remove_reference :amounts, :recorder, foreign_key: { to_table: :users }, type: :uuid
  end
end
