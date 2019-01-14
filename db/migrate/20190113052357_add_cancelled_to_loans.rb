class AddCancelledToLoans < ActiveRecord::Migration[5.2]
  def change
  	add_column :loans, :cancelled, :boolean, default: false
  end
end
