class AddInterestOnCapitalAccountToShareCapitals < ActiveRecord::Migration[5.2]
  def change
    add_reference :share_capitals, :interest_on_capital_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
