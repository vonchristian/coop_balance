class AddCodeToTimeDeposits < ActiveRecord::Migration[5.2]
  def change
    add_column :time_deposits, :code, :string
    add_index :time_deposits, :code, unique: true
  end
end
