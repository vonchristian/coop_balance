class AddCashAccountToBankingAgents < ActiveRecord::Migration[6.0]
  def change
    add_reference :banking_agents, :cash_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
