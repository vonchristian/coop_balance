class AddEquityAccountToShareCapitalApplications < ActiveRecord::Migration[5.2]
  def change
    add_reference :share_capital_applications, :equity_account, foreign_key: { to_table: :accounts }, type: :uuid 
  end
end
