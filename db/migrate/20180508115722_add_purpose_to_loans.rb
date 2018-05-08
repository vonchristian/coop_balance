class AddPurposeToLoans < ActiveRecord::Migration[5.2]
  def change
    add_column :loans, :purpose, :text
  end
end
