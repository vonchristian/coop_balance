class AddOfficeToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_reference :accounts, :office, foreign_key: true, type: :uuid
  end
end
