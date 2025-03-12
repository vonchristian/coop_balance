class AddAccountCategoryToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :accounts, :account_category, foreign_key: true, type: :uuid
  end
end
