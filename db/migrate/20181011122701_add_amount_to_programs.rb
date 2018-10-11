class AddAmountToPrograms < ActiveRecord::Migration[5.2]
  def change
    add_column :programs, :amount, :decimal
  end
end
