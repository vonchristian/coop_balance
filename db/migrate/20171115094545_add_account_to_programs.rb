class AddAccountToPrograms < ActiveRecord::Migration[5.1]
  def change
    add_reference :programs, :account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
