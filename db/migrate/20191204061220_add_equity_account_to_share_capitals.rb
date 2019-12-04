class AddEquityAccountToShareCapitals < ActiveRecord::Migration[6.0]
  def change
    add_reference :share_capitals, :equity_account, foreign_key: { to_table: :accounts }, type: :uuid 
  end
end
