class AddRecorderIdToAmounts < ActiveRecord::Migration[5.1]
  def change
    add_reference :amounts, :recorder, foreign_key: { to_table: :users }, type: :uuid
  end
end
