class RemoveInterestOnCapitalAccountFromShareCapitals < ActiveRecord::Migration[6.0]
  def change
    remove_reference :share_capitals, :interest_on_capital_account, null: false, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
