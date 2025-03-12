class RemoveAccountCategoryFromAccounts < ActiveRecord::Migration[6.0]
  def change
    remove_reference :accounts, :account_category, null: false, foreign_key: true, type: :uuid
  end
end
