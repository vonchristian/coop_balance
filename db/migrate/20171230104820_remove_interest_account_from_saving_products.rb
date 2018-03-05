class RemoveInterestAccountFromSavingProducts < ActiveRecord::Migration[5.1]
  def change
    remove_reference :saving_products, :interest_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
